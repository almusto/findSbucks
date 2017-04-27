//
//  HandleSearch.swift
//  FindStarbucks
//
//  Created by Alessandro Musto on 3/31/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit


final class ApiManager {

  fileprivate var neCorner: CLLocationCoordinate2D!
  fileprivate var swCorner: CLLocationCoordinate2D!
  fileprivate var placesClient: GMSPlacesClient!
  fileprivate let store = CoreDataStack.store
  var currentLocation: CLLocation!

  init() { placesClient = GMSPlacesClient.shared() }

    //MARK: - Current location search and distance from
    func calculateSearchFieldFromCurrentLocation(withDistance miles: Double) {
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude

        let degreesVertical: Double = miles/69
        let degreesHorizontal = degreesVertical / (cos(currentLatitude))
        let northLatitude = currentLatitude + degreesVertical
        let southLatitude = currentLatitude - degreesVertical
        let eastLongitude = currentLongitude + degreesHorizontal
        let westLongitude = currentLongitude - degreesHorizontal

        neCorner = CLLocationCoordinate2D(latitude: northLatitude, longitude: eastLongitude)
        swCorner = CLLocationCoordinate2D(latitude: southLatitude, longitude: westLongitude)
    }

    //calulates distance between two coordinates

    func haversineDinstance(toLocation: CLLocationCoordinate2D) -> Double {
        let radius: Double = 3959.0
        let haversin = { (angle: Double) -> Double in
          return (1 - cos(angle))/2
        }

        let ahaversin = { (angle: Double) -> Double in
          return 2*asin(sqrt(angle))
        }

        let dToR = { (angle: Double) -> Double in
          return (angle / 360) * 2 * Double.pi
        }

        if let location = currentLocation {
          let lat1 = dToR(location.coordinate.latitude)
          let lon1 = dToR(location.coordinate.longitude)
          let lat2 = dToR(toLocation.latitude)
          let lon2 = dToR(toLocation.longitude)

          return radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
        }

        return 0
    }

  //MARK: - Google places api calls

    func getNearbyStarbucks(completion: @escaping () -> ()) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let bounds = GMSCoordinateBounds(coordinate: neCorner, coordinate: swCorner)

        placesClient.autocompleteQuery("starbucks", bounds: bounds, filter: filter, callback: {( results, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.store.deleteAll()

            if let results = results {
                var complete = results.count
                for result in results {
                    if let id = result.placeID {
                        self.getPlaceDetails(id) { success in
                            complete -= 1
                            if complete == 0 {
                                completion()
                            }
                        }
                    }
                }
            }
        })
    }

    func getPlaceDetails(_ placeID: String, completion: @escaping (Bool) -> ()) {
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) in
            if let _ = error {
                completion(false)
                return
            }
            guard let place = place else {
                completion(false)
                return
            }
            let distance = self.haversineDinstance(toLocation: place.coordinate)
            self.store.store(starbucks: place, distance: distance)
            completion(true)
        })
    }

}
