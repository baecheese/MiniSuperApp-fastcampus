//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import Foundation

public struct AddPaymentMethodInfo {
  public let number: String
  public let cvc: String
  public let expiration: String
  
  public init(
    number: String,
    cvc: String,
    expiration: String
  ) {
    self.number = number
    self.cvc = cvc
    self.expiration = expiration
  }
}
