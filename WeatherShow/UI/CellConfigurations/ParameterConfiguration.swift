//
//  ParameterConfiguration.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit

protocol ParameterConfiguration: UIContentConfiguration {
	var title: String { get }
	var value: String { get }
}

extension ParameterConfiguration {
	func makeContentView() -> any UIView & UIContentView {
		ParameterView(weatherConfiguration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		self
	}
}

final class HumidityConfiguration: ParameterConfiguration {
	let title: String
	let value: String
	
	init(from weather: WeatherData) {
		title = "Humidity"
		value = "\(weather.current.humidity) %"
	}
}

final class PressureConfiguration: ParameterConfiguration {
	let title: String
	let value: String
	
	init(from weather: WeatherData, celsius: Bool) {
		title = "Pressure"
		value = celsius ? "\(weather.current.pressure_mb) mBar" : "\(weather.current.pressure_in) inches"
	}
}

final class UVIndexConfiguration: ParameterConfiguration {
	let title: String
	let value: String
	
	init(from weather: WeatherData) {
		title = "UV Index"
		value = "\(weather.current.uv)"
	}
}

final class WindConfiguration: ParameterConfiguration {
	let title: String
	let value: String
	
	init(from weather: WeatherData, celsius: Bool) {
		title = "Wind \(weather.current.wind_dir)"
		value = celsius ? "\(weather.current.wind_kph) km/h" : "\(weather.current.wind_mph) mph"
	}
}

//case uvIndex = 1
//case wind
