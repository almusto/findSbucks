//
//  AppDelegate.swift
//  FindStarbucks
//
//  Created by Alessandro Musto on 3/30/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(Secrets.gogolePlacesKey)
        GMSServices.provideAPIKey(Secrets.googleMapsKey)

        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        let layout = UICollectionViewFlowLayout()
        let mainView = StarbucksListCVC(collectionViewLayout: layout)
        navController.viewControllers = [mainView]
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

