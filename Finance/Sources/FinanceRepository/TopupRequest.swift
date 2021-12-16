//
//  TopupRequest.swift
//  
//
//  Created by 배지영 on 2021/12/16.
//

import Foundation
import Network

struct TopupRequest: Request {
  typealias Output = TopupResponse
  
  var endpoint: URL
  var method: HTTPMethod
  var query: QueryItems
  var header: HTTPHeader
  
  init(baseURL: URL, amount: Double, paymentMethod: String) {
    self.endpoint = baseURL.appendingPathComponent("/topup")
    self.method = .post
    self.query = [
      "amount": amount,
      "paymentMethodID": paymentMethod
    ]
    self.header = [:]
  }
  
}

struct TopupResponse: Decodable {
  let status: String
}
