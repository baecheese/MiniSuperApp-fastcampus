//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/15.
//

import Foundation

public struct PaymentMethod: Decodable {
  public let id: String
  public let name: String
  public let digits: String
  public let color: String // backend에서 보통 hex string으로 내려준다
  public let isPrimary: Bool
  
  public init(
    id: String,
    name: String,
    digits: String,
    color: String,
    isPrimary: Bool
  ) {
    self.id = id
    self.name = name
    self.digits = digits
    self.color = color
    self.isPrimary = isPrimary
  }
  
}
