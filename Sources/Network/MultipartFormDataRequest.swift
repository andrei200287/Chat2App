//
//  MultipartFormDataRequest.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation

struct MultipartFormDataRequest {
    static let boundary: String = UUID().uuidString
    
    private var httpBody = NSMutableData()

    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }

    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(MultipartFormDataRequest.boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    func addDataField(named name: String, data: Data, mimeType: String, filename: String) {
        httpBody.append(dataFormField(named: name, data: data, filename: filename, mimeType: mimeType))
    }

    private func dataFormField(named name: String,
                               data: Data,
                               filename: String,
                               mimeType: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(MultipartFormDataRequest.boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\" \r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
    
    var httpBodyData: Data {
        let httpBody = self.httpBody
        httpBody.append("--\(MultipartFormDataRequest.boundary)--")
        return httpBody as Data
    }
    
}
