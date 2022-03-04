//
//  CardOnFileMock.swift
//  
//
//  Created by 배지영 on 2022/03/04.
//

import Foundation
@testable import TopupImp
import FinanceEntity

final class CardOnFileBuildableMock: CardOnFileBuildable {
  
  var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
  var buildCallCount: Int = 0
  var buildPaymentMethods: [PaymentMethod]?
  
  func build(withListener listener: CardOnFileListener, paymentMethods: [PaymentMethod]) -> CardOnFileRouting {
    self.buildCallCount += 1
    self.buildPaymentMethods = paymentMethods
    guard let buildHandler = buildHandler else {
      fatalError()
    }
    return buildHandler(listener)
  }
  
}
