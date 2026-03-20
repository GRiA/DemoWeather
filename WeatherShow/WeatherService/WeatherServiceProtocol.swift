//
//  WeatherServiceProtocol.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import Foundation
import CoreLocation
import RxSwift

public protocol WeatherServiceProtocol {
	func refresh() -> Observable<Void>
}
