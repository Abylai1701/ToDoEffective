//
//  NilEncoding.swift
//  AutoEasy
//
//  Created by Abylaikhan Abilkayr on 01.06.2024.
//

import Alamofire
import Foundation

struct NilEncoding: ParameterEncoding {
    static let `default` = NilEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        guard let parameters = parameters else { return urlRequest }
        
        // Преобразование параметров в JSON
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        return urlRequest
    }
}


