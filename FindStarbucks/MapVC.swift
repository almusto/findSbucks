//
//  MapVC.swift
//  FindStarbucks
//
//  Created by Alessandro Musto on 3/31/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit
import GoogleMaps


class MapVC: UIViewController {

    var starbucks: Starbucks!

    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: starbucks.latitude, longitude: starbucks.longitude, zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: starbucks.latitude, longitude: starbucks.longitude)
        marker.title = "Starbucks"
        marker.snippet = "Get your Coffee On!"
//      marker.icon = UIImage(named: "logo")

        marker.map = mapView
    }

}
