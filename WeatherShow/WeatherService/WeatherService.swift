//
//  WeatherService.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import Foundation
import CoreLocation
import RxSwift
import Factory
import Moya
import RxMoya
import RxRelay

public final class WeatherService: WeatherServiceProtocol {
	
	@Injected(\WeatherShowContainer.currentLocation)
	private var locationRelay
	
	@Injected(\WeatherShowContainer.weatherData)
	private var weatherDataRelay
	
	@Injected(\WeatherShowContainer.weatherProvider)
	private var provider
	
	private let disposeBag = DisposeBag();
	
	init() {
		locationRelay.subscribe(onNext: { [weak self] event in
			guard let self else { return }
			
			switch event {
				case .noData:
					break
				case .error(let err):
					self.weatherDataRelay.accept(.error(err))
				case .exists:
					self.refresh()
						.subscribe { _ in }
						.disposed(by: self.disposeBag)
			}
		})
		.disposed(by: disposeBag)
		
		NotificationCenter.default.addObserver(
			forName: AppNotification.refreshWeather.name,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self else { return }
			self.refresh()
				.subscribe { _ in }
				.disposed(by: self.disposeBag)
		}
	}
	
	public func requestWeather(for location: CLLocation) -> Single<WeatherData> {
		return provider.rx
			.request(
				.forecast(
					lat: location.coordinate.latitude,
					lon: location.coordinate.longitude,
					days: 3
				)
			)
			.timeout(.seconds(10), scheduler: MainScheduler.instance)
			.map(WeatherData.self)
	}
	
	public func refresh() -> Observable<Void> {
		weatherDataRelay.accept(.updating)
		switch locationRelay.value {
			case .error(let error):
				weatherDataRelay.accept(.error(error))
				return requestWeather(for: .moscow)
					.map { [weak self] in
						self?.weatherDataRelay.accept(.data($0))
						return ()
					}
					.catch { [weak self] in
						self?.weatherDataRelay.accept(.error($0))
						return .error($0)
					}
					.asObservable()
			case .exists(let location):
				return requestWeather(for: location)
					.map { [weak self] in
						self?.weatherDataRelay.accept(.data($0))
						return ()
					}
					.catch { [weak self] in
						self?.weatherDataRelay.accept(.error($0))
						return .error($0)
					}
					.asObservable()
			case .noData:
				return .error(Errors.notAvailable)
		}
	}
}

public extension WeatherService {
	enum Errors: Error {
		case notAvailable
	}
}
