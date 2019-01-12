//
//  UIColorHex.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/17.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//
// This code's reference : https://qiita.com/Kyomesuke3/items/eae6216b13c651254f64

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
