//
//  DateFormatterHelper.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation

public class DateFormatterHelper {
    
    public static func format(date: Date,locale: Locale = Locale.current) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        dateformatter.locale = locale

        return dateformatter.string(from: date)
        
    }
}
