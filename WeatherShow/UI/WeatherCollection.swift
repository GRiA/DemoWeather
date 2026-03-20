//
//  WeatherCollection.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit

final class WeatherCollection: UICollectionView {
	public private(set) var weatherDataSource: WeatherDataSource! {
		didSet {
			dataSource = weatherDataSource
		}
	}
	static var instance: WeatherCollection {
		let collection = WeatherCollection(
			frame: .zero,
			collectionViewLayout: WeatherLayout()
		)
		collection.weatherDataSource = WeatherDataSource(collectionView: collection)
		return collection
	}
}

