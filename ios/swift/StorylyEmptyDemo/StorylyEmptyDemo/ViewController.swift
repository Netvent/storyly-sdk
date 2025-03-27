//
//  ViewController.swift
//  StorylyEmptyDemo
//
//  Created by Haldun Melih Fadillioglu on 27.03.2025.
//

import UIKit
import Storyly
import SDWebImage

let TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6MjQwNDIsInQiOjF9.Uj9rEBowMUOP4zqueJQ8stXJXHdFOKoac8sKUEM8K5M"

class ViewController: UIViewController {

    private var storyGroups: [VerticalFeedGroup]? {
        didSet {
            let groups = storyGroups ?? []
            staggeredGridView.updateData(Array(groups.shuffled().prefix(6)))
        }
    }

    private lazy var staggeredGridView = {
        let gridView = StaggeredGridView()
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.onSelect = { [weak self] storyGroup in
            guard let self = self else { return }
            _ = self.storylyView.openStory(storyGroupId: storyGroup.uniqueId)
        }
        return gridView
    }()
    private lazy var storylyView = StorylyVerticalFeedView(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()

        setupStaggeredGridView()
        setupStoryly()
    }
    
    private func setupStoryly() {
        storylyView.storylyVerticalFeedDelegate = self
        storylyView.rootViewController = self
        storylyView.storylyVerticalFeedInit = StorylyVerticalFeedInit(storylyId: TOKEN)
    }
    
    private func setupStaggeredGridView() {
        view.addSubview(staggeredGridView)
        NSLayoutConstraint.activate([
            staggeredGridView.topAnchor.constraint(equalTo: view.topAnchor),
            staggeredGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            staggeredGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            staggeredGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: StorylyVerticalFeedDelegate {
    func verticalFeedLoaded(_ view: STRVerticalFeedView, feedGroupList: [VerticalFeedGroup], dataSource: StorylyDataSource) {
        print("Storyly: verticalFeedLoaded: \(feedGroupList) \(dataSource)")
        storyGroups = feedGroupList
    }
}


class StaggeredGridView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    private var storyGroups: [VerticalFeedGroup] = []
    
    var onSelect: (VerticalFeedGroup) -> Void = { _ in }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            return StaggeredGridView.createLayout()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StaggerCell.self, forCellWithReuseIdentifier: StaggerCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func updateData(_ storyGroups: [VerticalFeedGroup]) {
        self.storyGroups = storyGroups
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaggerCell.identifier, for: indexPath) as? StaggerCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: storyGroups[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect(storyGroups[indexPath.row])
    }
    
    static func createLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1.0 / 3.0

        let largeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2 * fraction), heightDimension: .fractionalWidth(2 * fraction))
        let smallSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))

        let largeItem = NSCollectionLayoutItem(layoutSize: largeSize)
        let smallItem = NSCollectionLayoutItem(layoutSize: smallSize)

        let smallColumnItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        )
        let smallColumn = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(2 * fraction)),
            subitems: [smallColumnItem, smallColumnItem]
        )
        smallColumn.interItemSpacing = .fixed(0)

        let firstRow = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2 * fraction)),
            subitems: [largeItem, smallColumn]
        )
        firstRow.interItemSpacing = .fixed(0)

        let secondRow = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(fraction)),
            subitems: [smallItem, smallItem, smallItem]
        )
        secondRow.interItemSpacing = .fixed(0)

        let mainGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)),
            subitems: [firstRow, secondRow]
        )
        mainGroup.interItemSpacing = .fixed(0)

        let section = NSCollectionLayoutSection(group: mainGroup)
        section.interGroupSpacing = 0
        return section
    }
}

class StaggerCell: UICollectionViewCell {
    static let identifier = "StaggerCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with storyGroup: VerticalFeedGroup) {
        imageView.st_setImage(with: storyGroup.iconUrl)
    }
}
