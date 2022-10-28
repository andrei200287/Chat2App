//
//  HTTPClient.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        if let getParams = endpoint.getParams {
            var queryItems: [URLQueryItem] = []
            for param in getParams {
                let queryItem = URLQueryItem(name: param.key, value: param.value)
                queryItems.append(queryItem)
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) =
                (endpoint.imageBody == nil) ?
                    try await URLSession.shared.data(for: request, delegate: nil) :
                    try await URLSession.shared.upload(for: request, from: endpoint.imageBody!)
            print("data = \(String(bytes: data, encoding: .utf8)), response = \(response), request = \(request)")
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                    return .success(decodedResponse)
                } catch  {
                    print(error)
                    return .failure(.decode)
                }
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
