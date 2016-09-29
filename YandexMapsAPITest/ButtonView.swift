//
//  RouteButtonView.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 25.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonView: UIButton {
	
	var image: UIImage?
	
	override func layoutSubviews() {
		
		if let image = image {
			let squre: (CGFloat) -> CGFloat = { $0 * $0 }
			let innerRectSize = sqrt(squre(bounds.width/2))
			let _imageView = UIImageView(image: image)
			_imageView.frame = CGRect(x: bounds.midX - innerRectSize/2, y: bounds.midY - innerRectSize/2, width: innerRectSize, height: innerRectSize)
			addSubview(_imageView)
		}
		
	}
	
	
	override func draw(_ rect: CGRect) {
		let cap = CAShapeLayer()
		cap.shadowColor = UIColor.black.cgColor
		cap.shadowRadius = 3.0
		cap.shadowOpacity = 0.3
		cap.shadowOffset = CGSize(width: 0, height: 0)
		cap.path = UIBezierPath(ovalIn: bounds).cgPath
		cap.fillColor = UIColor(white: 1, alpha: 0.8).cgColor
		layer.addSublayer(cap)
		
	}
	
	
	
}
