//
//  DoubleExtension.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

extension Double {
    func formattedToCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = NSLocale.current
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
