//
//  HoursConfiguration.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import RxSwift
import RegexBuilder
import Factory
import RxMoya
import Moya

final class HoursConfiguration: UIContentConfiguration {
	let hour: String
	let temperature: String
	let symbol: Single<UIImage?>
	
	init?(with hour: HourData, celsius: Bool) {
		if let hourValue = hour.time.extractHour {
			self.hour = "\(hourValue)"
		} else {
			self.hour = "--"
		}
		
		self.temperature = celsius ? "\(hour.temp_c)°C" : "\(hour.temp_f)°F"
		let imageApi = WeatherShowContainer.shared.imageProvider()
		self.symbol = imageApi.rx
			.request(.cdnImage(hour.condition.icon))
			.map {
				try? $0.mapImage()
			}
	}
	
	func makeContentView() -> any UIView & UIContentView {
		HourDataView(weatherConfiguration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		self
	}
}

private extension String {
	var extractHour: Int? {
		//2026-03-19 00:00
		guard
			let date = DateFormatter.hourTimeFormatter.date(from: self)
		else {
			return nil
		}
		let calendar = Calendar.current
		let components = calendar.dateComponents([.hour], from: date)
		return components.hour
	}
}

extension DateFormatter {
	static let hourTimeFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		return dateFormatter
	}()
}
