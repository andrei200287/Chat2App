//
//  Date+extension.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

extension Date {
    
    func appDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = .current
        return formatter.string(from: self)
    }
    
}
