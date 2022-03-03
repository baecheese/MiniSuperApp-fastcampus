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
import FinanceRepositoryTestSupport
import CombineSchedulers

@testable import TopupImp

final class EnterAmountPresentableMock: EnterAmountPresentable {
  
  var listener: EnterAmountPresentableListener?
  
  var updateSelectedPaymentMethodCallCount = 0
  var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel?
  
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
  
  var mainQueue: AnySchedulerOf<DispatchQueue> { .immediate }
  
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
  /// SuperPayRepositoryMock은 여러 곳에서 테스트 할 것이기 때문에 테스트 폴더가 아닌 Finance의 라이브러리로 만듬
  var superPayRepository: SuperPayRepository = SuperPayRepositoryMock()
  
}

final class EnterAmountListenerMock: EnterAmountListener {
  
  var enterAmountDidTapCloseCount: Int = 0
  func enterAmountDidTapClose() {
    enterAmountDidTapCloseCount += 1
  }
  
  var enterAmountDidTapPaymentMethodCount: Int = 0
  func enterAmountDidTapPaymentMethod() {
    enterAmountDidTapPaymentMethodCount += 1
  }
  
  var enterAmountDidFinishTopupCount: Int = 0
  func enterAmountDidFinishTopup() {
    enterAmountDidFinishTopupCount += 1
  }
  
  
}
