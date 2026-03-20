//
//  LocationConfiguration.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import RxSwift
import Factory
import RxMoya
import Moya

final class LocationConfiguration: UIContentConfiguration {
	let title: String
	let temperature: String
	let condition: String
	let icon: Single<UIImage?>
	let feelsLike: String
	let isCelsius: Bool
	var action : (() -> Void)?
	
	
	init(with weather: WeatherData, celsius: Bool) {
		title = "\(weather.location.name)/\(weather.location.country)"
		condition = weather.current.condition.text
		isCelsius = celsius
		
		temperature = String(
			format: "%.1lf%@",
			celsius ? weather.current.temp_c : weather.current.temp_f,
			celsius ? "℃" : "℉"
		)
		
		feelsLike = String(
			format: "Feels like %.1lf%@",
			celsius ? weather.current.feelslike_c : weather.current.feelslike_f,
			celsius ? "℃" : "℉"
		)
		
		let imageApi = WeatherShowContainer.shared.imageProvider()
		icon = imageApi.rx
			.request(.cdnImage(weather.current.condition.icon))
			.map {
				try? $0.mapImage()
			}
	}
	
	func makeContentView() -> any UIView & UIContentView {
		LocationView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		return self
	}
	
	
}
