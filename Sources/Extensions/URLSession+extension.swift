//
//  URLSession+extension.swift
//  
//
//  Created by Andrei Solovjev on 28/10/2022.
//

import Foundation

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from request: URLRequest) async throws -> (Data, URLResponse) {
         try await withCheckedThrowingContinuation { continuation in
             let task = self.dataTask(with: request, completionHandler: { data, response, error in
                 guard let data = data, let response = response else {
                     let error = error ?? URLError(.badServerResponse)
                     return continuation.resume(throwing: error)
                 }

                 continuation.resume(returning: (data, response))
             })

             task.resume()
        }
    }
}
