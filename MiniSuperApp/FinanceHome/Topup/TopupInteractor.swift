//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  
  func attachAddPaymentMethod()
  func dettachAddPaymentMethod()
  
  func attachEnterAmount()
  func dettachEnterAmount()
  
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func dettachCardOnFile()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  private let dependency: TopupInteractorDependency
   
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private var paymentMethods: [PaymentMethod] {
    dependency.cardOnFileRepository.cardOnFile.value
  }
  
  init(
    dependency: TopupInteractorDependency
  ) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    if let firstCard = dependency.cardOnFileRepository.cardOnFile.value.first {
      // 금액 입력 화면
      dependency.paymentMethodStream.send(firstCard)
      router?.attachEnterAmount()
    } else {
      // 카드 추가 화면
      router?.attachAddPaymentMethod()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.dettachAddPaymentMethod()
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    
  }
  
  func enterAmountDidTapClose() {
    router?.dettachAddPaymentMethod()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    // topup에서 attach할 때, 필요한 정보 넘겨주는 것이 좋을 것
    router?.attachCardOnFile(paymentMethods: paymentMethods)
  }
  
  func cardOnFileDidTapClose() {
    router?.dettachCardOnFile()
  }
  
  func cardOnFileDidTapAddNewCard() {
    // attach add card
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.dettachCardOnFile()
  }
  
}
