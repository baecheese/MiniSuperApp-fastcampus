//
//  EnterAmountMock.swift
//  
//
//  Created by 배지영 on 2022/01/12.
//

import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
@testable import TopupImp

final class EnterAmountPresentableMock: EnterAmountPresentable {
  
  var listener: EnterAmountPresentableListener?
  
  var updateSelectedPaymentMethodCallCount = 0
  var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel
  
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
    updateSelectedPaymentMethodCallCount += 1
    updateSelectedPaymentMethodViewModel = viewModel
  }
  
  var startLoadingCount = 0
  
  func startLoading() {
    startLoadingCount += 1
  }
  
  var stopLoadingCount = 0
  
  func stopLoading() {
    stopLoadingCount += 1
  }
  
  init() { }
  
}

final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
  
  var selectedPaymentMoethodSubject = CurrentValuePublisher<PaymentMethod>(
     PaymentMethod(
      id: "",
      name: "",
      digits: "",
      color: "",
      isPrimary: false
     )
  )
  
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> {
    selectedPaymentMoethodSubject
  }
  var superPayRepository: SuperPayRepository
  
}
