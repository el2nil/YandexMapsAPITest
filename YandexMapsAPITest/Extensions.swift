//
//  Extensions.swift
//  YandexMapsAPITest
//
//  Created by Danil Denshin on 27.09.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import Foundation

extension String {
	
	func stringByAddingPercentEncodingForURLQueryValue() -> String? {
		let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
		
		return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
	}
	
}

extension Dictionary {
	
	func stringFromHttpParameters() -> String {
		let parameterArray = self.map { (key, value) -> String in
			let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
			let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
			return "\(percentEscapedKey)=\(percentEscapedValue)"
		}
		
		return parameterArray.joined(separator: "&")
	}
	
}
