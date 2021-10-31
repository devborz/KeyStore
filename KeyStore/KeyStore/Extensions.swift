//
//  Extensions.swift
//  KeyStore
//
//  Created by Усман Туркаев on 30.10.2021.
//

import UIKit

extension String {
    var image: UIImage? {
        return UIImage(systemName: self)
    }
}

extension Date {
    static var nearestPointDivisibleBy30: Date {
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        if second < 29 {
            let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate)
            return date ?? currentDate
        } else {
            let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 30, of: currentDate)
            return date ?? currentDate
        }
    }
}
