//
//  WeatherAPI.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import Foundation
import Moya
import Alamofire

enum WeatherAPI {
	case today(lat: Double, lon: Double)
	case forecast(lat: Double, lon: Double, days: Int)
}

extension WeatherAPI: TargetType {
	var task: Moya.Task {
		.requestParameters(parameters: parameters ?? [:], encoding: parametersEncoding)
	}
	
	var headers: [String : String]? {
		[:]
	}
	
	var baseURL: URL { URL(string: .weatherBaseURL)! }
	
	var path: String {
		switch self {
			case .today:
					.currentPath
			case .forecast:
					.forecastPath
				
		}
	}
	
	var parameters: [String: Any]? {
		switch self {
			case let .today(lat, lon):
				[
					.qKey: "\(lat),\(lon)",
					.keyKey: String.weatherApiKey
				]
			case let .forecast(lat, lon, days):
				[
					.qKey: "\(lat),\(lon)",
					.keyKey: String.weatherApiKey,
					.daysKey: days
				]
		}
	}
	
	var parametersEncoding: ParameterEncoding {
		URLEncoding.default
	}
	
	var method: Moya.Method {
		.get
	}
}

private extension String {
	static let weatherBaseURL = "https://api.weatherapi.com/v1"
	static let weatherApiKey = "fa8b3df74d4042b9aa7135114252304"
	static let currentPath = "/current.json"
	static let forecastPath = "/forecast.json"
	
	static let qKey = "q"
	static let keyKey = "key"
	static let daysKey = "days"
}
