//
//  DayDataView.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import SnapKit
import RxSwift

final class DayDataView: UIView & UIContentView {
	private var disposeBag = DisposeBag()
	var configuration: any UIContentConfiguration {
		get { weatherConfiguration }
		set { weatherConfiguration = newValue as! DayConfiguration }
	}
	var weatherConfiguration: DayConfiguration {
		didSet { updateWithNewConfiguration() }
	}
	
	private lazy var dayLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.top.bottom.equalToSuperview()
			$0.leading.equalToSuperview().offset(16)
		}
		return label
	}()
	private lazy var temperatureLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.textColor = .colorText
		addSubview(label) {
			$0.top.bottom.equalToSuperview()
			$0.trailing.equalToSuperview().inset(8)
		}
		return label
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		addSubview(imageView) {
			$0.centerY.equalToSuperview()
			$0.trailing.equalTo(temperatureLabel.snp.leading).offset(-10)
			$0.width.height.equalTo(32)
		}
		return imageView
	}()
	
	init(weatherConfiguration: DayConfiguration) {
		self.weatherConfiguration = weatherConfiguration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is DayConfiguration
	}
}

private extension DayDataView {
	func updateWithNewConfiguration() {
		disposeBag = DisposeBag()
		dayLabel.text = weatherConfiguration.title
		temperatureLabel.text = "\(weatherConfiguration.temperatureMin) / \(weatherConfiguration.temperatureMax)"
		weatherConfiguration.weatherIcon.subscribe { [weak self] in
			self?.imageView.image = $0
		}
		.disposed(by: disposeBag)
	}
}
