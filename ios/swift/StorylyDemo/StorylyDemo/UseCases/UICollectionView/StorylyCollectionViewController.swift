//
//  UICollectionViewController.swift
//  StorylyDemo
//
//  Created by Levent Oral on 5.05.2022.
//  Copyright © 2022 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class StorylyCollectionViewController: UIViewController {
    
    private let collectionViewItemCount = 100
    private lazy var collectionView: UICollectionView = StorylyCollectionView(frame: self.view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.collectionView)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
    }
}

extension StorylyCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorylyCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? StorylyCollectionViewCell else {
            fatalError()
        }
        cell.initialize(rootViewController: self)
        return cell
    }
}

class StorylyCollectionView: UICollectionView {
    init(frame: CGRect) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: frame.width, height: 120)
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(StorylyCollectionViewCell.self, forCellWithReuseIdentifier: StorylyCollectionViewCell.reuseIdentifier)
    }
    
    internal required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

class StorylyCollectionViewCell: UICollectionViewCell {
    internal static var reuseIdentifier = String(describing: StorylyCollectionViewCell.self)
    
    private lazy var storylyView: StorylyView = StorylyView()
    
    internal func initialize(rootViewController: UIViewController) {
        self.addSubview(self.storylyView)
        self.storylyView.translatesAutoresizingMaskIntoConstraints = false
        self.storylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        self.storylyView.rootViewController = rootViewController
        self.storylyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.storylyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.storylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.storylyView.backgroundColor = .random
        self.storylyView.storyGroupListHorizontalEdgePadding = 16.0
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 0.3
        )
    }
}
