//
//  StarbucksListCVC.swift
//  FindStarbucks
//
//  Created by Alessandro Musto on 3/30/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit
import MapKit


class StarbucksListCVC: UICollectionViewController {

    fileprivate var locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation!

    fileprivate let sectionInsets = UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)


    let apiManager = ApiManager()
    let store = CoreDataStack.store


    override func viewDidLoad() {
        super.viewDidLoad()

        self.store.fetchStarbucks()
        self.setUpLocationManager()

        collectionView?.backgroundColor = UIColor.lightGray
        collectionView!.register(StarbucksCell.self, forCellWithReuseIdentifier: "sbucksCell")

        navigationItem.title = "Nearby Starbucks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(searchNearbyStarbucks(_:)))

    }

    func searchNearbyStarbucks(_ sender: UIBarButtonItem) {
        apiManager.currentLocation = currentLocation
        apiManager.calculateSearchFieldFromCurrentLocation(withDistance: 1)

        apiManager.getNearbyStarbucks() {
            DispatchQueue.main.async {
                self.store.fetchStarbucks()
                self.collectionView?.reloadData()
            }

            if self.store.fetchedStarbucks.isEmpty {
                self.noStarbucksWithinOneMile()
            }
        }
    }

}
    // MARK: - Collection view data source

extension StarbucksListCVC  {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.fetchedStarbucks.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sbucksCell", for: indexPath) as! StarbucksCell
        cell.starbucks = store.fetchedStarbucks[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MapVC()
        vc.starbucks = store.fetchedStarbucks[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }

  //flash on cell reload
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            cell.alpha = 0
        }, completion: { (bool) in
            UIView.animate(withDuration: 1, animations: {
                cell.alpha = 1
            })
        })
    }
}


//MARK: - UICollectionViewDelegateFlowLayout


extension StarbucksListCVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        let width = availableWidth
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//MARK: - CLLocationManagerDelegate


extension StarbucksListCVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations[locations.count - 1];

        if  currentLocation == nil {
            currentLocation = latestLocation
        }

    }

  //handle location error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertVC = UIAlertController(title: "Unable to get current location", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: - Location setup and no location alert

extension StarbucksListCVC {

    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
    }

    func noStarbucksWithinOneMile() {
        let alertVC = UIAlertController(title: "No Starbucks nearby", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}


