//
//  ErrorConfiguration.swift
//  WeatherShow
//
//  Created by Anton Grishin on 20.03.2026.
//

import UIKit

enum ErrorTypes: Int {
	case locationServiceUnavailable
	case weatherServiceUnavailable
	case unknown
}

final class ErrorConfiguration: UIContentConfiguration {
	let title: String
	let subtitle: String
	let icon: UIImage?
	let action: (()->Void)?
	let buttonTitle: String
	let iconColor: UIColor
	
	init(with errorType: ErrorTypes?) {
		let error = errorType ?? .unknown
		self.title = error.title
		self.subtitle = error.subtitle
		self.action = error.action
		self.icon = error.icon
		self.buttonTitle = error.buttonTitle
		self.iconColor = error.iconColor
	}
	
	func makeContentView() -> any UIView & UIContentView {
		ErrorView(weatherConfiguration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		return self
	}
}

private extension ErrorTypes {
	var title: String {
		switch self {
			case .locationServiceUnavailable:
				"Location service unavailable"
			case .weatherServiceUnavailable:
				"Weather service unavailable"
			case .unknown:
				"Error"
		}
	}
	var subtitle: String {
		switch self {
			case .locationServiceUnavailable:
				"Location service is disabled. Please enable it in settings. Default location (Moscow/Russia) will be used."
			case .weatherServiceUnavailable:
				"Weather server not responding. Try again by pressing the refresh button."
			case .unknown:
				"Something went wrong. Not critical, just ignore this message."
		}
	}
	var icon: UIImage? {
		switch self {
			case .locationServiceUnavailable:
				UIImage(systemName: "exclamationmark.triangle.fill")?.withRenderingMode(.alwaysTemplate)
			case .weatherServiceUnavailable:
				UIImage(systemName: "exclamationmark.octagon.fill")?.withRenderingMode(.alwaysTemplate)
			case .unknown:
				UIImage(systemName: "exclamationmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
		}
	}
	var iconColor: UIColor {
		switch self {
			case .locationServiceUnavailable:
					.yellow
			case .weatherServiceUnavailable, .unknown:
					.red
		}
	}
	var action: (()->Void)? {
		switch self {
			case .locationServiceUnavailable:
				{
					let path = UIApplication.openSettingsURLString
					if let url = URL(string: path) {
						UIApplication.shared.open(url)
					}
				}
			case .weatherServiceUnavailable:
				{
					NotificationCenter.default.post(name: AppNotification.refreshWeather.name, object: nil)
				}
			case .unknown:
				{
					NotificationCenter.default.post(name: AppNotification.dropErrors.name, object: nil)
				}
		}
	}
	var buttonTitle: String {
		switch self {
			case .locationServiceUnavailable:
				"Open settings"
			case .weatherServiceUnavailable:
				"Retry"
			case .unknown:
				"Ok"
		}
	}
}
