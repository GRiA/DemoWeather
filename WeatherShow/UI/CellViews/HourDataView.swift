//
//  HourDataView.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import SnapKit
import RxSwift

final class HourDataView: UIView & UIContentView {
	private var disposeBag = DisposeBag()
	var configuration: any UIContentConfiguration {
		get { weatherConfiguration }
		set { weatherConfiguration = newValue as! HoursConfiguration }
	}
	var weatherConfiguration: HoursConfiguration {
		didSet { updateWithNewConfiguration() }
	}
	
	init(weatherConfiguration: HoursConfiguration) {
		self.weatherConfiguration = weatherConfiguration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	private lazy var hourLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.top.equalToSuperview().offset(4)
			$0.centerX.equalToSuperview()
		}
		return label
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		addSubview(imageView) {
			$0.center.equalToSuperview()
			$0.width.height.equalTo(32)
		}
		return imageView
	}()
	
	private lazy var temperatureLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.bottom.equalToSuperview().offset(-4)
			$0.centerX.equalToSuperview()
		}
		return label
	}()
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is HoursConfiguration
	}
}

private extension HourDataView {
	func updateWithNewConfiguration() {
		disposeBag = DisposeBag()
		hourLabel.text = weatherConfiguration.hour
		temperatureLabel.text = weatherConfiguration.temperature
		weatherConfiguration.symbol.subscribe { [weak self] in
			self?.imageView.image = $0
		}
		.disposed(by: disposeBag)
	}
}
