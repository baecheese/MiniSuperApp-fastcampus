//
//  AddCardRequest.swift
//  
//
//  Created by 배지영 on 2022/01/05.
//

import Foundation
import Network
import FinanceEntity

struct AddCardRequest: Request {
  typealias Output = AddCardResponse

  let endpoint: URL
  let method: HTTPMethod
  let query: QueryItems
  let header: HTTPHeader
    
  init(baseURL: URL, info: AddPaymentMethodInfo) {
    self.endpoint = baseURL.appendingPathComponent("/addCard")
    self.method = .post
    self.query = [
      "number": info.number,
      "cvc": info.cvc,
      "expiration": info.expiration
    ]
    self.header = [:]
  }
  
}

struct AddCardResponse: Decodable {
  let card: PaymentMethod
}
