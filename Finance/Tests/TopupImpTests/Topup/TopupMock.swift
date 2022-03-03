//
//  TopupMock.swift
//  
//
//  Created by 배지영 on 2022/03/03.
//

import Foundation
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineUtil
import FinanceEntity

@testable import TopupImp

final class TopupInteractorDependencyMock: TopupInteractorDependency {
  
  var cardOnFileRepository: CardOnFileRepository = CardOnFileRepositoryMock()
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> = .init(
    PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
  )
  
}
