//
//  NumberFormatter.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation

public class NumberFormatterHelper {
    public static func formattedCurrency(amount:Int) -> String {
        let number = NSNumber(value:amount)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return  numberFormatter.string(from: number) ?? "\(amount)"
    }
}
