//
//  ErrorView.swift
//  WeatherShow
//
//  Created by Anton Grishin on 20.03.2026.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ErrorView: UIView & UIContentView {
	private var disposeBag = DisposeBag()
	
	var configuration: any UIContentConfiguration {
		get { weatherConfiguration }
		set { weatherConfiguration = newValue as! ErrorConfiguration}
	}
	var weatherConfiguration: ErrorConfiguration {
		didSet {
			updateWithNewConfiguration()
		}
	}
	
	private lazy var titleLabel: UILabel =  {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.textColor = .colorText
		label.contentMode = .topLeft
		addSubview(label) {
			$0.top.equalToSuperview().offset(8)
			$0.leading.equalTo(imageView.snp.trailing).offset(8)
			$0.trailing.equalToSuperview().inset(16)
			$0.height.equalTo(24)
		}
		return label
	}()
	
	private lazy var subtitleLabel: UILabel =  {
		let label = UILabel()
		label.numberOfLines = -1
		label.font = .systemFont(ofSize: 14, weight: .light)
		label.textColor = .colorText
		label.contentMode = .topLeft
		addSubview(label) {
			$0.top.equalTo(titleLabel.snp.bottom).offset(4)
			$0.leading.equalTo(imageView.snp.trailing).offset(8)
			$0.trailing.equalToSuperview().inset(16)
		}
		return label
	}()
	
	private lazy var imageView: UIImageView =  {
		let imageView = UIImageView()
		addSubview(imageView) {
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().offset(16)
			$0.width.height.equalTo(48)
		}
		return imageView
	}()
	
	private lazy var actionButton: UIButton? =  {
		guard
			weatherConfiguration.action != nil
		else {
			return nil
		}
		
		let button = UIButton()
		button.setTitleColor(.systemBlue, for: .normal)
		addSubview(button) {
			$0.bottom.equalToSuperview().inset(8)
			$0.leading.equalTo(imageView.snp.trailing).offset(8)
			$0.top.equalTo(subtitleLabel.snp.bottom).offset(8)
			$0.height.equalTo(44)
		}
		return button
	}()
	
	init(weatherConfiguration: ErrorConfiguration) {
		self.weatherConfiguration = weatherConfiguration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is ErrorConfiguration
	}
	
	override var intrinsicContentSize: CGSize {
		var height = titleLabel.frame.height + subtitleLabel.frame.height
		if let actionButton {
			height += actionButton.frame.height
		}
		return CGSize(width: .greatestFiniteMagnitude, height: height)
	}
}

private extension ErrorView {
	func updateWithNewConfiguration() {
		disposeBag = DisposeBag()
		titleLabel.text = weatherConfiguration.title
		subtitleLabel.text = weatherConfiguration.subtitle
		imageView.image = weatherConfiguration.icon
		imageView.tintColor = weatherConfiguration.iconColor
		if let actionButton {
			actionButton.setTitle(weatherConfiguration.buttonTitle, for: .normal)
			actionButton.rx
				.tap
				.subscribe(onNext: { [weak self] in
					self?.weatherConfiguration.action?()
				})
				.disposed(by: disposeBag)
		}
		invalidateIntrinsicContentSize()
	}
}
