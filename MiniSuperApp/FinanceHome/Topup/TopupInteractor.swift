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
}

protocol TopupListener: AnyObject {
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  private let dependency: TopupInteractorDependency
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
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
    if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
      // 카드 추가 화면
      router?.attachAddPaymentMethod()
    } else {
      // 금액 입력 화면
      router?.attachEnterAmount()
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
  
  
}
