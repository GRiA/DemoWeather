//
//  ParameterView.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import SnapKit

final class ParameterView: UIView & UIContentView {
	var configuration: any UIContentConfiguration {
		get { weatherConfiguration }
		set { weatherConfiguration = newValue as! ParameterConfiguration }
	}
	var weatherConfiguration: ParameterConfiguration {
		didSet {
			updateWithNewConfiguration()
		}
	}
	
	private lazy var captionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.centerX.equalToSuperview()
			$0.top.equalToSuperview().offset(8)
		}
		return label
	}()
	
	private lazy var valueLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 32, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.center.equalToSuperview()
		}
		return label
	}()
	
	init(weatherConfiguration: ParameterConfiguration) {
		self.weatherConfiguration = weatherConfiguration
		super.init(frame: .zero)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is ParameterConfiguration
	}
}

private extension ParameterView {
	func updateWithNewConfiguration() {
		captionLabel.text = weatherConfiguration.title
		valueLabel.text = weatherConfiguration.value
	}
}
