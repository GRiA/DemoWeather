//
//  UIView+Utils.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit
import SnapKit

extension UIView {
	func addSubview(_ view: UIView, _ closure: (_ make: ConstraintMaker) -> Void ) {
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
		view.snp.makeConstraints(closure)
	}
}

