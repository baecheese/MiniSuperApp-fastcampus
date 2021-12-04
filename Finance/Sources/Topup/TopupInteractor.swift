//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs
import FinanceEntity
import FinanceRepository
import CombineUtil
import SuperUI
import RIBsUtil

public protocol TopupRouting: Routing {
  func cleanupViews()
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType)
  func dettachAddPaymentMethod()
  
  func attachEnterAmount()
  func dettachEnterAmount()
  
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func dettachCardOnFile()
  
  func popToRoot()
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
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
  
  // 충전 금액 입력 페이지가 루트인지
  private var isEnterAmountRoot: Bool = false
  
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
  
  // 첫 로드 시
  override func didBecomeActive() {
    super.didBecomeActive()
    if let firstCard = dependency.cardOnFileRepository.cardOnFile.value.first {
      // 충전 금액 입력 화면
      isEnterAmountRoot = true
      dependency.paymentMethodStream.send(firstCard)
      router?.attachEnterAmount()
    } else {
      // 카드 추가 화면
      isEnterAmountRoot = false
      router?.attachAddPaymentMethod(closeButtonType: .close)
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
    if false == isEnterAmountRoot {
      listener?.topupDidClose()
    }
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    dependency.paymentMethodStream.send(paymentMethod)
    if isEnterAmountRoot {
      router?.popToRoot()
    } else {
      // 카드 추가 후에는 충전 금액 입력 페이지로
      router?.attachEnterAmount()
    }
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
    router?.attachAddPaymentMethod(closeButtonType: .back)
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.dettachCardOnFile()
  }
  
  func enterAmountDidFinishTopup() {
    listener?.topupDidFinish()
  }
  
}
