//
//  LocationService.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import Foundation
import CoreLocation
import Factory
import RxRelay

final class LocationService: NSObject {
	
	@Injected(\WeatherShowContainer.currentLocation)
	var locationRelay
	
	private let locationManager = {
		let manager = CLLocationManager()
		manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		return manager
	}()
	
	override init() {
		super.init()
		locationManager.delegate = self
	}
}

extension LocationService: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkStatus()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let loc = locations.last else { return }
		locationRelay.accept(.exists(loc))
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
		locationRelay.accept(.error(error))
	}
}

private extension LocationService {
	func checkStatus() {
		let authStatus = locationManager.authorizationStatus
		switch authStatus {
			case .authorizedAlways, .authorizedWhenInUse:
				locationManager.startUpdatingLocation()
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .restricted, .denied:
				locationRelay.accept(.error(Errors.locationServiceUnavailable))
			@unknown default:
				break
		}
	}
}

extension LocationService {
	enum Errors: Error {
		case locationServiceUnavailable
	}
}
