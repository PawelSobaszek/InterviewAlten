//
//  DataExtensions.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 03/03/2023.
//

import Foundation

extension Data {
    func printJSON() {
        if let JSONString = jsonString() {
            Log.i(JSONString)
        }
    }
    
    func printErrorJSON() {
        if let JSONString = jsonString() {
            Log.e(JSONString)
        }
    }
    
    func getErrorMessage() -> String? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? Parameters {
            guard let message = json["message"] as? String else { return nil }
            return message
        } else {
            guard let JSONString = jsonString() else { return nil }
            return JSONString
        }
    }
    
    func jsonString() -> String? {
        String(data: self, encoding: String.Encoding.utf8)
    }
}
