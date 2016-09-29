//
//  FromSearchController.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 23.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
	
	fileprivate var _searchBar: CustomSearchBar
	
	override var searchBar: UISearchBar {
		return _searchBar
	}
	
	override init(searchResultsController: UIViewController?) {
		_searchBar = CustomSearchBar()
		_searchBar.showsCancelButton = false
		super.init(searchResultsController: searchResultsController)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		_searchBar = CustomSearchBar()
		_searchBar.showsCancelButton = false
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
		return nil
	}
	

}
