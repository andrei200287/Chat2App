//
//  NSMutableData+extension.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation

extension NSMutableData {
    
    func append(_ string: String) {
      if let data = string.data(using: .utf8) {
        self.append(data)
      }
    }
    
}
