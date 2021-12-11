//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/12/04.
//

import Foundation

struct Formatter {
  
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
}
