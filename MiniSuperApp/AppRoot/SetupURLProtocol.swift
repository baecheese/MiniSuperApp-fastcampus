//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/01/05.
//

import Foundation

func setupURLProtocol() {
  
  /// TopupResponse Decodable 참고해서 구현해야 할 것
  /// 현재는 임시 데이터
  let topupResponse: [String: Any] = [
    "status": "success"
  ]
  
  let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
  
  let addCardResponse: [String: Any] = [
    "card": [
      "id": "000",
      "name": "새카드",
      "digits": "**** 0101",
      "color": "",
      "isPrimary": false
    ]
  ]
  
  let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
  
  SuperAppURLProtocol.successMock = [
    "/api/v1/topup": (200, topupResponseData),
    "/api/v1/addCard": (200, addCardResponseData)
  ]
}
