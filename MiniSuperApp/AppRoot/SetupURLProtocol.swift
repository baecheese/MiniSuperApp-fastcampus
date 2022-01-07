//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/01/05.
//

import Foundation

func setupURLProtocol() {
  
  /// TopupResponse Decodable 참고해서 구현해야 할 것
  /// Topup Mock data
  let topupResponse: [String: Any] = [
    "status": "success"
  ]
  
  let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
  
  /// addCard  Mock data
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
  
  /// CardOnFile Mock data
  let cardOnFileResponse: [String: Any] = [
    "cards": [
      [
        "id": "0",
        "name": "우리은행",
        "digits": "0123",
        "color": "#f19a38ff",
        "isPrimary": "false"
      ],
      [
        "id": "1",
        "name": "신한카드",
        "digits": "0987",
        "color": "#3478f6ff",
        "isPrimary": "false"
      ],
      [
        "id": "2",
        "name": "현대카드",
        "digits": "1234",
        "color": "#78c5f5ff",
        "isPrimary": "false"
      ]
    ]
  ]
  
  let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
  
  SuperAppURLProtocol.successMock = [
    "/api/v1/topup": (200, topupResponseData),
    "/api/v1/addCard": (200, addCardResponseData),
    "/api/v1/cards": (200, cardOnFileResponseData)
  ]
}
