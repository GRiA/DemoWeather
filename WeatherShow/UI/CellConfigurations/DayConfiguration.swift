//
//  DayConfiguration.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import RxSwift
import Factory
import RxMoya
import Moya

final class DayConfiguration: UIContentConfiguration {
	let title: String?
	let temperatureMin: String
	let temperatureMax: String
	let weatherIcon: Single<UIImage?>
	
	init?(with weather: WeatherData, index: Int, celsius: Bool) {
		guard
			let forecast = weather.forecast,
			let dayData = forecast.forecastday.indices.contains(index) ? weather.forecast?.forecastday[index] : nil
		else {
			return nil
		}
		title = dayData.date.prettyPresent
		temperatureMin = String(
			format: "%.1lf%@",
			celsius ? dayData.day.mintemp_c : dayData.day.mintemp_f,
			celsius ? "°C" : "°F"
		)
		temperatureMax = String(
			format: "%.1lf%@",
			celsius ? dayData.day.maxtemp_c : dayData.day.maxtemp_f,
			celsius ? "°C" : "°F"
		)
		let imageApi = WeatherShowContainer.shared.imageProvider()
		weatherIcon = imageApi.rx
			.request(.cdnImage(dayData.day.condition.icon))
			.map {
				try? $0.mapImage()
			}
	}
	
	func makeContentView() -> any UIView & UIContentView {
		DayDataView(weatherConfiguration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		self
	}
}

private extension String {
	var prettyPresent: String? {
		guard
			let date = DateFormatter.dirtyDate.date(from: self)
		else {
			return nil
		}
		let calendar = Calendar.current
		let components = calendar.dateComponents([.month, .day, .weekday], from: date)
		if let weekday = components.weekday,
		   calendar.weekdaySymbols.indices.contains(weekday) {
			return "\(calendar.weekdaySymbols[weekday])"
		}
		return "\(components.day!) \(calendar.monthSymbols[components.month!])"
	}
}

extension DateFormatter {
	static let dirtyDate: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}()
}
