//
//  SearchViewController.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 23.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit
import CoreLocation

class PointsToRouteViewController: UIViewController, UITextFieldDelegate, SearchTableViewControllerDelegate {
	
	@IBOutlet weak var fromSearchBar: UITextField!
	@IBOutlet weak var toSearchBar: UITextField!
	@IBOutlet weak var makeRouteButton: UIBarButtonItem!
	
	@IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
		let startViewController = storyboard!.instantiateViewController(withIdentifier: "startViewController")
		startViewController.modalTransitionStyle = .crossDissolve
		dismiss(animated: true, completion: nil)
	}
	
	// SearchTableViewControllerDelegate

	var currentRoutePoint: RoutePoints?
	var pointA: YandexGeocoder.GeoObject?
	var pointB: YandexGeocoder.GeoObject? { didSet { checkRoutingPossibility() } }
	
	func searchTableViewController(_ searchTableVC: SearchTableViewController, didSelectGeoObject geoObject: YandexGeocoder.GeoObject?) {
		if currentRoutePoint == .pointA {
			pointA = geoObject
			fromSearchBar.text = geoObject?.name
			currentRoutePoint = nil
		} else if currentRoutePoint == .pointB {
			pointB = geoObject
			toSearchBar.text = geoObject?.name
			currentRoutePoint = nil
		}
	}
	
	private func checkRoutingPossibility() {
		makeRouteButton.isEnabled = pointB != nil
	}
	
	enum RoutePoints {
		case pointA
		case pointB
	}
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fromSearchBar.delegate = self
		toSearchBar.delegate = self
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let searchVC = segue.destination as? SearchTableViewController {
			if let textField = sender as? UITextField, textField == toSearchBar {
				searchVC.delegate = self
				searchVC.title = "Куда"
				currentRoutePoint = .pointB
				searchVC.searchController.searchBar.text = textField.text
			} else if let textField = sender as? UITextField, textField == fromSearchBar {
				searchVC.delegate = self
				searchVC.title = "Откуда"
				currentRoutePoint = .pointA
				searchVC.searchController.searchBar.text = textField.text
			}
		}
		if let identifier = segue.identifier, identifier == "ShowRoutes" {
			if let routeVC = segue.destination as? RouteViewController {
				
				if pointA == nil {
					let myPoint = YandexGeocoder.GeoObject(name: "Мое местоположение")
					myPoint.point = (UIApplication.shared.delegate as? AppDelegate)?.currentLocation
					routeVC.pointA = myPoint
				} else {
					routeVC.pointA = pointA
				}
				
				routeVC.pointB = pointB
			}
			
		}
	}
	
	// MARK: Text field delegate
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		performSegue(withIdentifier: "Search Address", sender: textField)
		return false
	}
	
}
