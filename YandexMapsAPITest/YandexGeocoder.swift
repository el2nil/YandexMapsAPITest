//
//  YandexGeocoder.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 25.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol YandexGeocoderDelegate {
	func yandexGeocoger(didRecieveGeocodeData data: [YandexGeocoder.GeoObject])
}

class YandexGeocoder {
	
	typealias GeocodeDictionary = [String: Any]
	
	var delegate: YandexGeocoderDelegate?
	
	fileprivate var dataTask: URLSessionDataTask?
	
	fileprivate let session = URLSession(configuration: .default)
	
	class GeoObject {
		
		var name: String
		var description: String?
		var point: CLLocationCoordinate2D?
		
		init(name: String) {
			self.name = name
		}
		
	}
	
	fileprivate func addParametersToURL(url: String, parameters: [String: String]) -> String {
		var result = url
		if parameters.count > 0 {
			for (key, value) in parameters {
				if let _ = result.characters.index(of: "?") {
					result += "&" + key + "=" + value
				} else {
					result += "?" + key + "=" + value
				}
			}
		}
		return result
	}
	
	fileprivate struct GeocodeParameters {
		static let geocode = "geocode"
		static let format = "format"
		static let geocodeURL = "https://geocode-maps.yandex.ru/1.x/"
		static let json = "json"
	}
	
	func getGeocodeObjects(forSearchText searchText: String) {
		
		if dataTask != nil {
			dataTask?.cancel()
		}
		
		let params = [
			GeocodeParameters.geocode: searchText,
			GeocodeParameters.format: "json"]
		
		let stringAppendedParameters = addParametersToURL(url: GeocodeParameters.geocodeURL, parameters: params)
		let encodedString = stringAppendedParameters.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
		let url = URL(string: encodedString!)
		
		if url != nil {
			
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
			dataTask = session.dataTask(with: url!) { (data, response, error) in
				
				DispatchQueue.main.async {
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
				}
				if let error = error {
					print(error.localizedDescription)
				} else if let httpResponse = response as? HTTPURLResponse {
					if httpResponse.statusCode == 200 {
						
						if let jsonData = data {
							if let geocodeDictionary = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? GeocodeDictionary {
								if let geoObjectsArray = self.parseGeocodeDictionary(geocodeDictionary) {
									DispatchQueue.main.async {
										self.delegate?.yandexGeocoger(didRecieveGeocodeData: geoObjectsArray)
									}
								} else {
									print("Error: can't parse geocode data")
								}
							} else {
								print("Error: unknown JSON format")
							}
						}
					}
				}
			}
			dataTask?.resume()
		}
			
	}
	
	fileprivate struct GeocodeKeys {
		static let resonse = "response"
		static let geoObjectCollection = "GeoObjectCollection"
		static let featureMember = "featureMember"
		static let description = "description"
		static let name = "name"
		static let point = "Point"
		static let pos = "pos"
		static let geoObject = "GeoObject"
	}
	
	fileprivate func parseGeocodeDictionary(_ geocodeDictionary: GeocodeDictionary) -> [GeoObject]? {
		
		var geoObjectsResultArray = [GeoObject]()
		
		var geoObjectsArray: [GeocodeDictionary]?
		
		if let response = geocodeDictionary[GeocodeKeys.resonse] as? GeocodeDictionary {
			if let geoObjectCollection = response[GeocodeKeys.geoObjectCollection] as? GeocodeDictionary {
				if let featureMember = geoObjectCollection[GeocodeKeys.featureMember] as? [GeocodeDictionary] {
					geoObjectsArray = featureMember
				}
			}
		}
		
		guard geoObjectsArray != nil else { return nil }
		
		for geoObject in geoObjectsArray! {
			
			if let geoObjectProperties = geoObject[GeocodeKeys.geoObject] as? GeocodeDictionary {
				
				let name = geoObjectProperties[GeocodeKeys.name] as? String ?? ""
				let newGeoObject = GeoObject(name: name)
				newGeoObject.description = geoObjectProperties[GeocodeKeys.description] as? String ?? ""
				let point = (geoObjectProperties[GeocodeKeys.point] as? [String:String])?[GeocodeKeys.pos] ?? ""
				let longitude = CLLocationDegrees(point.substring(to: point.characters.index(of: " ")!)) ?? 0.0
				let latitude = CLLocationDegrees(point.substring(from: point.index(after: point.characters.index(of: " ")!))) ?? 0.0
				newGeoObject.point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				
				geoObjectsResultArray.append(newGeoObject)
			}
		}
		
		return geoObjectsResultArray
	}
	
	
}
