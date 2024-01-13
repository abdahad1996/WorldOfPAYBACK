//
//  SortingPolicy.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 13.01.24.
//

import Foundation

public enum SortingCriteria {
    case bookingDate
    // Add more criteria if needed
}

public enum SortingDirection {
    case ascending
    case descending
}
public class SortingPolicy{
    public init(){}
    
    public static func sortItems(items:[TransactionItem],by criteria: SortingCriteria,direction: SortingDirection) -> [TransactionItem]{
        switch criteria {
        case .bookingDate:
            
            return items.sorted(by: {
                if direction == .ascending {
                    return $0.bookingDate < $1.bookingDate
                } else {
                    return $0.bookingDate > $1.bookingDate
                }
            })
            // Add more cases for other sorting criteria if needed
        }
    }
    
}
 
