//
//  Dropabble.swift
//  c0764112_Labassin.1
//
//  Created by Sandeep Jangra on 2020-01-14.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import MapKit

class DropabblePin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
