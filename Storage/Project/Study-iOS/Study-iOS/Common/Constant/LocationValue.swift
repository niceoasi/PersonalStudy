//
//  LocationValue.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 06/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation

class LocationValue {
    static let shared = LocationValue()
    
    enum ActivityType: Int {
        case other
        case automotiveNavigation // for automotive navigation
        case fitness // includes any pedestrian activities
        case otherNavigation // for other navigation cases (excluding pedestrian navigation), e.g. navigation for boats, trains, or planes
    }
    
    enum DesiredAccuracy: Double {
        case kCLLocationAccuracyBestForNavigation   = -2.0
        case kCLLocationAccuracyBest                = -1.0
        case kCLLocationAccuracyNearestTenMeters    = 10
        case kCLLocationAccuracyHundredMeters       = 100
        case kCLLocationAccuracyKilometer           = 1000
    }
    
    enum DistanceFilter {
    }
}

