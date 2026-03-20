//
//  WeatherLayout.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import UIKit

final class WeatherLayout: UICollectionViewCompositionalLayout {
	init() {
		super.init { section, _ in
			switch section {
				case 0: .errorsSection
				case 1: .locationSection
				case 2: .hoursSection
				case 3: .daysSection
				case 4: .parametersSection
				default: nil
			}
		}
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
}

private extension NSCollectionLayoutSection {
	static var locationSection: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .fractionalHeight(1.0)))
		item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
		
		let containerGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .absolute(168.0)),
			subitems: [item])
		
		let section = NSCollectionLayoutSection(group: containerGroup)
		return section
	}
	
	static var hoursSection: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 6.0),
											   heightDimension: .fractionalHeight(1.0)))
		item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
		
		let containerGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .absolute(96.0)),
			subitems: [item])
		
		let section = NSCollectionLayoutSection(group: containerGroup)
		section.orthogonalScrollingBehavior = .continuous
		
		return section
	}
	
	static var daysSection: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .fractionalHeight(1.0)))
		item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
		
		
		let containerGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .absolute(64.0)),
			subitems: [item]
		)
		
		let section = NSCollectionLayoutSection(group: containerGroup)
		return section
	}
	static var errorsSection: NSCollectionLayoutSection {
		let heightDimension = NSCollectionLayoutDimension.estimated(10)
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: heightDimension))
		item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
		
		
		let containerGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: heightDimension),
			subitems: [item]
		)
		
		let section = NSCollectionLayoutSection(group: containerGroup)
		return section
	}
	
	static var parametersSection: NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.5),
			heightDimension: .fractionalHeight(1.0))
		
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
		
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalWidth(0.5))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = .init(top: 2, leading: 0, bottom: 2, trailing: 0)
		return section
	}
}
