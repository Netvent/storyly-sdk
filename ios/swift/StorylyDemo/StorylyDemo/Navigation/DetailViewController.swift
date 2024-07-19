//
//  DetailViewController.swift
//  StorylyDemo
//
//  Created by Kadir Sancak on 18.07.2024.
//  Copyright © 2024 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    
    internal var onDismiss: (() -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onDismiss?()
    }
}


