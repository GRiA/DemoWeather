//
//  LocationView.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LocationView: UIView & UIContentView {
	private var disposeBag = DisposeBag()
	var configuration: any UIContentConfiguration {
		get { locationConfig }
		set { locationConfig = newValue as! LocationConfiguration}
	}
	var locationConfig: LocationConfiguration {
		didSet { updateWithNewConfiguration() }
	}
	init(configuration: LocationConfiguration) {
		self.locationConfig = configuration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	private lazy var locationNameLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 18, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.centerX.equalToSuperview()
			$0.top.equalToSuperview().offset(12)
		}
		return label
	}()
	
	private lazy var temperatureLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 32, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(locationNameLabel.snp.bottom).offset(10)
		}
		return label
	}()

	private lazy var conditionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 14, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(temperatureLabel.snp.bottom).offset(10)
		}
		return label
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		addSubview(imageView) {
			$0.centerY.equalTo(conditionLabel.snp.centerY)
			$0.trailing.equalTo(conditionLabel.snp.leading).offset(-8)
			$0.width.height.equalTo(32)
		}
		return imageView
	}()
	
	private lazy var feelsLikeLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 14, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.centerX.equalToSuperview()
			$0.top.equalTo(conditionLabel.snp.bottom).offset(10)
		}
		return label
	}()
	
	private lazy var toggleUnitsButton: UIButton = {
		let button = UIButton()
		button.setTitleColor(.colorText, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
		addSubview(button) {
			$0.left.equalToSuperview().offset(8)
			$0.bottom.equalToSuperview().inset(8)
		}
		return button
	}()
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is LocationConfiguration
	}
}

private extension LocationView {
	func updateWithNewConfiguration() {
		disposeBag = DisposeBag()
		locationNameLabel.text = locationConfig.title
		temperatureLabel.text = locationConfig.temperature
		conditionLabel.text = locationConfig.condition
		feelsLikeLabel.text = locationConfig.feelsLike
		locationConfig.icon
			.subscribe { [weak self] in
				self?.imageView.image = $0
			}
			.disposed(by: disposeBag)
		let title = locationConfig.isCelsius ? "°F" : "°C"
		toggleUnitsButton.setTitle( title, for: .normal)
		toggleUnitsButton.rx.tap.subscribe(onNext: { [weak self] in
			self?.locationConfig.action?()
		})
		.disposed(by: disposeBag)
	}
}
