//
//  GradientView.swift
//  StorylyDemo
//
//  Created by Yiğit Çalışkan on 5.10.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit

class GradientView: UIView {
    private let gradient: CAGradientLayer = CAGradientLayer()
    private var startPoint: CGPoint = CGPoint(x: 0, y: 1)
    private var endPoint: CGPoint = CGPoint(x: 0, y: 0)

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }

    public override func draw(_ rect: CGRect) {
        self.gradient.frame = self.bounds
        self.gradient.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
        self.gradient.locations = [0, 1]
        self.gradient.startPoint = startPoint
        self.gradient.endPoint = endPoint
        self.gradient.cornerRadius = cornerRadius
        if self.gradient.superlayer == nil {
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }
    
    @IBInspectable public var startColor: UIColor = .clear
    
    @IBInspectable public var endColor: UIColor = .clear
    
    @IBInspectable public var cornerRadius: CGFloat = 0
}
