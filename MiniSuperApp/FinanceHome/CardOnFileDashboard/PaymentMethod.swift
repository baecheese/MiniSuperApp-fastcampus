//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/15.
//

import Foundation

struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String // backend에서 보통 hex string으로 내려준다
  let isPrimary: Bool
}
