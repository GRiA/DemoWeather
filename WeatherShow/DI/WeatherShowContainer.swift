//
//  WeatherShowContainer.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import Foundation
import CoreLocation
import Factory
import RxRelay
import Moya

final class WeatherShowContainer: SharedContainer {
	static let shared = WeatherShowContainer()
	let manager = ContainerManager()
	
	public var currentLocation: Factory<BehaviorRelay<LocationState>> {
		self {
			BehaviorRelay<LocationState>(value: .exists(.moscow))
		}
		.cached
	}
	
	public var weatherService: Factory<WeatherServiceProtocol> {
		self {
			WeatherService()
		}
		.cached
	}
	
	public var weatherData: Factory<PublishRelay<WeatherResponse>> {
		self {
			PublishRelay<WeatherResponse>()
		}
		.cached
	}
	
	public var locationService: Factory<LocationService> {
		self {
			LocationService()
		}
		.cached
	}
	
	public var weatherProvider: Factory<MoyaProvider<WeatherAPI>> {
		self {
			MoyaProvider<WeatherAPI>()
		}
	}
	public var imageProvider: Factory<MoyaProvider<ImageApi>> {
		self {
			MoyaProvider<ImageApi>(
				requestClosure: { endpoint, closure in
					guard
						var request = try? endpoint.urlRequest()
					else {
						return
					}
					request.cachePolicy = .returnCacheDataElseLoad
					closure(.success(request))
				},
				plugins: []
			)
		}
		.cached
	}
}

extension CLLocation {
	nonisolated static let moscow: CLLocation = .init(latitude: 55.7558, longitude: 37.6173)
}
