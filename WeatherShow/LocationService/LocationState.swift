//
//  LocationState.swift
//  WeatherShow
//
//  Created by Anton Grishin on 20.03.2026.
//

import Foundation
import CoreLocation

public enum LocationState {
	case exists(CLLocation)
	case error(Error)
	case noData
}
