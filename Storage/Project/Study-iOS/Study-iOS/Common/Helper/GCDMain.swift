//
//  GCDMain.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 07/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
