//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/15.
//

import Foundation
import Combine

/// 서버 API로 호출해서 유저에게 등록된 카드 목록을 가져옴
/// 그 카드 목록은 data Stream으로 가지고 있음
/// 카드목록이 필요한 곳에 subscribe를 할 수 있도록 구성
protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
  
  /// 비동기 네트워킹일 것을 고려해서 AnyPyblisher로 return
  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
  
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
  
  /// HARD CODING - temp data
  private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
    PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
    PaymentMethod(id: "2", name: "현대카드", digits: "1234", color: "#78c5f5ff", isPrimary: false),
//    PaymentMethod(id: "3", name: "국민은행", digits: "3456", color: "#65c466ff", isPrimary: false),
//    PaymentMethod(id: "4", name: "카카오뱅크", digits: "6870", color: "#ffcc00ff", isPrimary: false),
//    PaymentMethod(id: "5", name: "안나와야 하는 카드", digits: "1010", color: "#ffcc00ff", isPrimary: false)
  ])
  
  
  func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
    let paymentMethod = PaymentMethod(id: "00", name: "new temp card", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
    var new = paymentMethodsSubject.value
    new.append(paymentMethod)
    paymentMethodsSubject.send(new)
    return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
  
}

