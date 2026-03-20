//
//  CommonNotifications.swift
//  WeatherShow
//
//  Created by Anton Grishin on 20.03.2026.
//

import Foundation

enum AppNotification: String {
	case refreshWeather
	case dropErrors
	
	var name: NSNotification.Name {
		return NSNotification.Name(rawValue: self.rawValue)
	}
}
