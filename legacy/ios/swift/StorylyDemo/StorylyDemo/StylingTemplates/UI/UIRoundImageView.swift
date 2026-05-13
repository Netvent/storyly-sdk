//
//  UIRoundImageView.swift
//  StorylyDemo
//
//  Created by Yiğit Çalışkan on 20.09.2021.
//  Copyright © 2021 App Samurai Inc. All rights reserved.
//

import UIKit

class UIRoundImageView: UIView {
    private var hasDoneLayout = false
    internal var cr: CGFloat?
    
    internal var isLoaded: Bool {
        get {
            return self.imageView.image != nil
        }
    }
    
    internal var borderColor: [UIColor] = [.clear, .clear] {
        didSet {
            self.gradientLayer?.colors = borderColorByLayoutDirection.map { $0.cgColor }
            self.addGradientLayer()
        }
    }
    
    private var borderColorByLayoutDirection: [UIColor] {
        get {
            return isLayoutDirectionLtr() ?  self.borderColor : self.borderColor.reversed()
        }
    }
    
    public lazy var imageView = UIImageView()
    
    private lazy var gradientLayer: CAGradientLayer? = {
        let _gradientLayer = CAGradientLayer()
        _gradientLayer.frame = CGRect(origin: .zero, size: self.frame.size)
        _gradientLayer.colors = borderColorByLayoutDirection.map { $0.cgColor }
        
        _gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        _gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        let _shapeLayer = CAShapeLayer()
        _shapeLayer.lineWidth = 4.0
        _shapeLayer.path = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: cr != nil ? cr! : self.frame.height / 2).cgPath
        _shapeLayer.strokeColor = UIColor.black.cgColor
        _shapeLayer.fillColor = UIColor.clear.cgColor
        _gradientLayer.mask = _shapeLayer
        
        return _gradientLayer
    }()
    
    required init(frame: CGRect, cornerRadius: CGFloat? = nil, imageContentMode: ContentMode? = .scaleToFill) {
        self.cr = cornerRadius
        super.init(frame: frame)
        self.setupView()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
    }
    
    internal func setImage(iconUrl: URL, contentMode: ContentMode = .scaleToFill, completion: (() -> Void)? = nil) {
        self.imageView.contentMode = contentMode
        self.imageView.sd_setImage(with: iconUrl) { [weak self] image, error, type, url in
            self?.backgroundColor = .clear
            completion?()
        }
    }
    
    internal func setImage(image: UIImage, contentMode: ContentMode = .scaleToFill) {
        self.imageView.image = image
        self.imageView.contentMode = contentMode
    }
    
    internal func cancelImageRequest() {
        self.imageView.sd_cancelCurrentImageLoad()
        self.imageView.layer.removeAllAnimations()
        self.imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.hasDoneLayout { return }
        self.hasDoneLayout = true
        self.clipsToBounds = true
        
        self.layer.cornerRadius = cr != nil ? cr! : self.frame.height / 2
        self.layer.masksToBounds = true
        
        self.imageView.clipsToBounds = true
        if !hasBorder {
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.imageView.layer.cornerRadius = cr != nil ? max(cr!, 0) : self.imageView.frame.height / 2
        } else {
            self.imageView.frame = CGRect(x: 4, y: 4, width: self.frame.width - 8, height: self.frame.height - 8)
            self.imageView.layer.cornerRadius = cr != nil ? max(cr! - 4, 0) : self.imageView.frame.height / 2
        }
        
    }
    
    private func addGradientLayer() {
        guard self.gradientLayer?.superlayer == nil else { return }
        if let gradientLayer = self.gradientLayer {
            self.layer.addSublayer(gradientLayer)
        }
    }
    
    internal func isLayoutDirectionLtr() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet { self.cr = cornerRadius }
    }
    
    @IBInspectable public var hasBorder: Bool = true
}
