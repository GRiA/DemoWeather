//
//  WeatherDataSource.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import Moya
import RxSwift

enum Sections: String {
	case location
	case hours
	case days
	case weatherParameters
	case errors
}

enum LocationItem: Int {
	case location = 1
}

private extension Int {
	static let locationOffset = 0
	static let hoursOffset = 10
	static let daysOffset = 50
	static let parametersOffset = 100
	static let errorsOffset = 1000
}

enum ParameterItem: Int {
	case uvIndex = 1
	case wind
	case humidity
	case pressure
}

final class WeatherDataSource: UICollectionViewDiffableDataSource<Sections, Int> {
	static private let displayedParameters: [ParameterItem] = [.humidity, .uvIndex, .wind, .pressure]
	
	private var weatherData: WeatherData?
	private let locationCellRegistration = UICollectionView.locationCellRegistration
	private let hourCellRegistration = UICollectionView.hourCellRegistration
	private let dayCellRegistration = UICollectionView.dayCellRegistration
	private let parameterCellRegistration = UICollectionView.parameterCellRegistration
	private let errorsCellRegistration = UICollectionView.errorsCellRegistration
	
	private var isCelsius = true
	private var displayedHours: [HourData] = []
	
	init(collectionView: UICollectionView) {
		super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			guard
				let dataSource = collectionView.dataSource as? WeatherDataSource,
				let section = dataSource.sectionIdentifier(for: indexPath.section)
			else {
				return nil
			}
			let cellRegistration = dataSource.cellRegistration(for: section)
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
			cell.contentConfiguration = dataSource.configuration(for: indexPath, itemIdentifier)
			return cell
		}
		
		var snapshot = snapshot()
		snapshot.appendSections([.errors, .location, .hours, .days, .weatherParameters])
		apply(snapshot)
	}
	
	func setWeather(_ weatherData: WeatherData) {
		self.weatherData = weatherData
		var snapshot = snapshot()
		
		if snapshot.itemIdentifiers(inSection: .location).isEmpty {
			snapshot.appendItems([LocationItem.location.rawValue], toSection: .location)
		} else {
			snapshot.reconfigureItems([LocationItem.location.rawValue])
		}
		
		if var hours = weatherData.forecast?.forecastday.first?.hour {
			let currentDate = Date()
			hours = hours.filter {
				guard
					let date = DateFormatter.hourTimeFormatter.date(from: $0.time)
				else {
					return false
				}
				return date > currentDate
			}
			
			if weatherData.forecast?.forecastday.indices.contains(1) ?? false,
			   let nextDay = weatherData.forecast?.forecastday[1].hour {
				hours.append(contentsOf: nextDay)
			}
			let items = hours.enumerated().map { index, _ in
				index + .hoursOffset
			}
			displayedHours = hours
			
			if snapshot.itemIdentifiers(inSection: .hours).isEmpty {
				snapshot.appendItems(items, toSection: .hours)
			} else {
				snapshot.reconfigureItems(items)
			}
		}
		
		if let days = weatherData.forecast?.forecastday {
			let items = days.enumerated().map{ index, _ in
				index + .daysOffset
			}
			if snapshot.itemIdentifiers(inSection: .days).isEmpty {
				snapshot.appendItems(items, toSection: .days)
			} else {
				snapshot.reconfigureItems(items)
			}
		}
		
		let items = Self.displayedParameters.map { $0.rawValue + .parametersOffset }
		if snapshot.itemIdentifiers(inSection: .weatherParameters).isEmpty {
			snapshot.appendItems(items, toSection: .weatherParameters)
		} else {
			snapshot.reconfigureItems(items)
		}
		apply(snapshot, animatingDifferences: true)
	}
	
	func addError(_ error: Error) {
		var snapshot = snapshot()
		snapshot.appendItems([error.type.rawValue + .errorsOffset], toSection: .errors)
		apply(snapshot, animatingDifferences: true)
	}
	
	func clearErrors() {
		var snapshot = snapshot()
		snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .errors))
		apply(snapshot, animatingDifferences: true)
	}
}

private extension WeatherDataSource {
	func cellRegistration(for section: Sections) -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		switch section {
			case .location: locationCellRegistration
			case .days: dayCellRegistration
			case .hours: hourCellRegistration
			case .weatherParameters: parameterCellRegistration
			case .errors: errorsCellRegistration
		}
	}
	func configuration(for indexPath: IndexPath, _ itemIdentifier: Int) -> UIContentConfiguration? {
		guard
			let section = sectionIdentifier(for: indexPath.section),
			let weatherData
		else {
			return ErrorConfiguration(with: ErrorTypes(rawValue: itemIdentifier - .errorsOffset))
		}
		
		switch section {
			case .errors:
				return ErrorConfiguration(with: ErrorTypes(rawValue: itemIdentifier - .errorsOffset))
			case .location:
				let config = LocationConfiguration(with: weatherData, celsius: isCelsius)
				config.action = { [weak self] in
					guard let self else { return }
					self.isCelsius.toggle()
					self.reload()
				}
				return config
			case .hours:
				return HoursConfiguration(with: displayedHours[indexPath.row], celsius: isCelsius)
			case .days:
				return DayConfiguration(with: weatherData, index: indexPath.row, celsius: isCelsius)
			case .weatherParameters:
				let param =  ParameterItem(rawValue: itemIdentifier - .parametersOffset)
				switch param {
					case .humidity:
						return HumidityConfiguration(from: weatherData)
					case .pressure:
						return PressureConfiguration(from: weatherData, celsius: isCelsius)
					case .uvIndex:
						return UVIndexConfiguration(from: weatherData)
					case .wind:
						return WindConfiguration(from: weatherData, celsius: isCelsius)
					default:
						return HumidityConfiguration(from: weatherData)
				}
		}
	}
	
	func reload() {
		var snapshot = snapshot()
		let items = snapshot.itemIdentifiers
		snapshot.reconfigureItems(items)
		apply(snapshot)
	}
}

private extension Error {
	var type: ErrorTypes {
		if (self as? LocationService.Errors) == .locationServiceUnavailable {
			.locationServiceUnavailable
		} else if (self as? WeatherService.Errors) != nil {
			.weatherServiceUnavailable
		} else if (self as? MoyaError) != nil {
			.weatherServiceUnavailable
		} else if (self as? RxError) != nil {
			.weatherServiceUnavailable
		} else {
			.unknown
		}
	}
}
