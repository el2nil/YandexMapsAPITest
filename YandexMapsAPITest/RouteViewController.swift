//
//  RouteViewController.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 26.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UIWebViewDelegate {
	
	var pointA: YandexGeocoder.GeoObject?
	var pointB: YandexGeocoder.GeoObject?

	@IBOutlet weak var webView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView.delegate = self
		
		let path = Bundle.main.path(forResource: "index", ofType: "html")
		
		var params = ""
		if let pointA = pointA?.point, let pointB = pointB?.point {
			
			let currentLocation = (UIApplication.shared.delegate as? AppDelegate)?.currentLocation
			
			params = [
				"latitudeA": String(pointA.latitude),
				"longitudeA": String(pointA.longitude),
				"latitudeB": String(pointB.latitude),
				"longitudeB": String(pointB.longitude),
				"crntLongitude": String(currentLocation?.longitude ?? 0),
				"crntLatitude": String(currentLocation?.latitude ?? 0)
				].stringFromHttpParameters()
		}
		
		let url = URL(string: "\(path!)?\(params)")
		
		webView.loadRequest(URLRequest(url: url!))

	}
	
	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		print("Error: failed loading web view")
	}

}
