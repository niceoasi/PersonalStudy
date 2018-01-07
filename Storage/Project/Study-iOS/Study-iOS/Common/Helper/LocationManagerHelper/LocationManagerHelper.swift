//
//  LocationManagerHelper.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 06/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import CoreLocation

// MARK: - LocationManagerHelper
class LocationManagerHelper: NSObject ,CLLocationManagerDelegate {
    static let shared = LocationManagerHelper()
    
    // MARK: Properties
    private let locationManager = CLLocationManager()
    var methodCallCount = 0
    var updateLocationCloser: ((_ latitude: Double, _ longitude: Double) -> Void)?
    
    // MARK: Life Cycle
    override init() {
        super.init()
        
        initLocationMnager()
    }
    
    private func initLocationMnager() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 0.0
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    }
    
    // MARK: Functions
    func startUpdateLocation() {
        locationManagerStart()
    }
    
    private func locationManagerStart() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationMangerStop()
        methodCallCount = 0
    }
    
    private func locationMangerStop() {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        methodCallCount += 1
    }
}

/*
 - activityType: CLActivityType: Int
 other
 automotiveNavigation // for automotive navigation
 fitness // includes any pedestrian activities
 otherNavigation // for other navigation cases (excluding pedestrian navigation), e.g. navigation for boats, trains, or planes
 
 - desiredAccuracy: CLLocationAccuracy
 kCLLocationAccuracyBestForNavigation   // -2.0
 kCLLocationAccuracyBest                // -1.0
 kCLLocationAccuracyNearestTenMeters    // 10
 kCLLocationAccuracyHundredMeters       // 100
 kCLLocationAccuracyKilometer           // 1000
 kCLLocationAccuracyThreeKilometers
 
 - distanceFilter: CLLocationDistance: Double => meter
 */
