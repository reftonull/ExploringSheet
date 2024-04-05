//
//  MathUtils.swift
//  SheetExploration
//
//  Created by Laksh Chakraborty on 4/5/24.
//

import Foundation

public func clip<T: FloatingPoint>(value: T, lower: T, upper: T) -> T {
    min(upper, max(value, lower))
}
