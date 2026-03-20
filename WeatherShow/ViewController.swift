//
//  ViewController.swift
//  WeatherShow
//
//  Created by Anton Grishin on 18.03.2026.
//

import UIKit
import Factory
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
	@Injected(\WeatherShowContainer.weatherData)
	var weatherRelay
	
	@Injected(\WeatherShowContainer.locationService)
	var locationService
	
	@Injected(\WeatherShowContainer.weatherService)
	var weatherService

	
	private var weatherCollection: WeatherCollection!
	private let disposeBag = DisposeBag()
	private var notificationSubscribe: NSObjectProtocol?
	
	deinit {
		if let notificationSubscribe {
			NotificationCenter.default.removeObserver(notificationSubscribe)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		weatherCollection = .instance
		view.addSubview(weatherCollection) {
			$0.edges.equalToSuperview()
		}
		weatherCollection.backgroundColor = .colorShadow
		weatherRelay
			.asDriver(onErrorJustReturn: .error(Errors.connectionError))
			.drive(with: self) {
				$0.updateData($1)
			}
			.disposed(by: disposeBag)
		
		notificationSubscribe = NotificationCenter.default.addObserver(forName: AppNotification.dropErrors.name, object: nil, queue: .main) { [weak self] _ in
			self?.weatherCollection.weatherDataSource.clearErrors()
		}
	}
	
	func updateData(_ weather: WeatherResponse) {
		switch weather {
			case .updating:
				weatherCollection.weatherDataSource.clearErrors()
			case .error(let err):
				weatherCollection.weatherDataSource.addError(err)
			case .data(let data):
				weatherCollection.weatherDataSource.setWeather(data)
			case .noData:
				break
		}
	}
}

private extension ViewController {
	enum Errors: Error {
		case connectionError
	}
}
