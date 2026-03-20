//
//  ImageApi.swift
//  WeatherShow
//
//  Created by Anton Grishin on 19.03.2026.
//

import Foundation
import Moya
import Alamofire

enum ImageApi {
	case cdnImage(String)
}

extension ImageApi: TargetType {
	var path: String { "" }
	var method: Moya.Method { .get }
	var headers: [String : String]? { nil }
	
	var baseURL: URL {
		if case let .cdnImage(urlString) = self {
			return URL(string: "https:\(urlString)")!
		}
		fatalError("Invalid path")
	}
	var task: Moya.Task {
		.requestPlain
	}
}
