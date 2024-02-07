//
//  DateExtensions.swift
//  ABMA
//
//  Created by Nate Condell on 2/6/24.
//  Copyright © 2024 Nathan Condell. All rights reserved.
//

import Foundation

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func dateOfTheMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}
