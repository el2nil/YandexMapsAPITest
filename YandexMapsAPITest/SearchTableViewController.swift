//
//  SearchResultsTableViewController.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 24.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

protocol SearchTableViewControllerDelegate {
	func searchTableViewController(_ searchTableVC: SearchTableViewController, didSelectGeoObject geoObject: YandexGeocoder.GeoObject?)
}

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, YandexGeocoderDelegate {
		
	var delegate: SearchTableViewControllerDelegate?
	
	// model
	fileprivate var searchResults: [YandexGeocoder.GeoObject] = [] { didSet { tableView.reloadData() } }
	
	var searchController: SearchController = SearchController(searchResultsController: nil)
	
	// MARK: YandexGeocoder
	
	fileprivate lazy var yandexGeocoder: YandexGeocoder = {
		let yandexGeocoder = YandexGeocoder()
		yandexGeocoder.delegate = self
		return yandexGeocoder
	}()
	
	func yandexGeocoger(didRecieveGeocodeData data: [YandexGeocoder.GeoObject]) {
		searchResults = data
	}
	
	// MARK: UISearchControllerDelegate
	
	func didPresentSearchController(_ searchController: UISearchController) {
		searchController.searchBar.becomeFirstResponder()
	}
	
	// MARK: UISearchBarDelegate
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if let text = searchBar.text, text == "" {
			searchResults.removeAll()
		}
	}
	
	// MARK: UISearchResultsUpdating protocol
	
	func updateSearchResults(for searchController: UISearchController) {
		
		if let searchText = searchController.searchBar.text {
			yandexGeocoder.getGeocodeObjects(forSearchText: searchText)
		}
	}
	
	// MARK: Lificycle
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if searchController.searchBar.text == "" {
			let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader")
			let button = UIButton()
			button.frame = headerCell!.bounds
			button.setTitle("Моё местоположение", for: .normal)
			button.setTitleColor(UIColor.blue, for: .normal)
			button.addTarget(self, action: #selector(selectCurrentLocation), for: .touchUpInside)
			headerCell?.addSubview(button)
			return headerCell
		}
		return nil
	}
	
	func selectCurrentLocation() {
		delegate?.searchTableViewController(self, didSelectGeoObject: nil)
		let _ = navigationController?.popViewController(animated: true)
	}


	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if searchController.searchBar.text == "" {
			return 40
		}
		return 0
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController.delegate = self
		searchController.searchBar.delegate = self
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.placeholder = "Введите адрес"
		
		tableView.tableHeaderView = searchController.searchBar
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		definesPresentationContext = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		searchController.isActive = true
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Address", for: indexPath)
		
		let geoObject = searchResults[indexPath.row]
		
		cell.textLabel?.text = geoObject.name
		cell.detailTextLabel?.text = geoObject.description
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.searchTableViewController(self, didSelectGeoObject: searchResults[indexPath.row])
		let _ = navigationController?.popViewController(animated: true)
	}
	
}
