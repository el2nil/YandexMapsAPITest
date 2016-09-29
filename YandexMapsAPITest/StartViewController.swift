//
//  ViewController.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 23.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class StartViewController: UIViewController, UIWebViewDelegate, CLLocationManagerDelegate {
	
	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var routeButton: ButtonView! { didSet { routeButton.image = UIImage(named: "Route") } }
	
	@IBAction func routeButtonAction(_ sender: ButtonView) {
		if let storyboard = storyboard {
			let vc = storyboard.instantiateViewController(withIdentifier: "routesNavController")
			vc.modalTransitionStyle = .crossDissolve
			present(vc, animated: true, completion: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView.delegate = self
		
	}
	
	override func viewDidAppear(_ animated: Bool) {

		let path = Bundle.main.path(forResource: "index", ofType: "html")
		
		var params = ""
		if let currentLocation = (UIApplication.shared.delegate as? AppDelegate)?.currentLocation {
			
			params = [
				"crntLongitude": String(currentLocation.longitude),
				"crntLatitude": String(currentLocation.latitude)
				].stringFromHttpParameters()
		}
		
		let url = URL(string: "\(path!)?\(params)")
		
		webView.loadRequest(URLRequest(url: url!))
		
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		
	}
	
	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		print("error")
	}
	
	
}

