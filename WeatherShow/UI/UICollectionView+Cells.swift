//
//  UICollectionView+Cells.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit

extension UICollectionView {
	static var locationCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		generateCellRegistration(with: 20)
	}
	static var hourCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		generateCellRegistration(with: 8)
	}
	static var dayCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		generateCellRegistration(with: 8)
	}
	static var parameterCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		generateCellRegistration(with: 20)
	}
	static var errorsCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		generateCellRegistration(with: 20)
	}
}

private extension UICollectionView {
	static func generateCellRegistration(with cornerRadius: CGFloat) -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, _, _ in
			var background = cell.defaultBackgroundConfiguration()
			background.backgroundColor = .colorBeige
			background.cornerRadius = cornerRadius
			background.strokeColor = .colorDark.withAlphaComponent(0.2)
			background.strokeWidth = 1
			cell.backgroundConfiguration = background
		}
	}
}
