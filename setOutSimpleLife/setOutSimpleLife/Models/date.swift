//
//  date.swift
//  setOutSimpleLife
//
//  Created by taha on 05/12/2020.
//

import Foundation
extension DateFormatter {
  func date(fromSwapiString dateString: String) -> Date? {
    // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
    self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    self.timeZone = TimeZone(abbreviation: "UTC")
    self.locale = Locale(identifier: "en_US_POSIX")
    return self.date(from: dateString)
  }
}
