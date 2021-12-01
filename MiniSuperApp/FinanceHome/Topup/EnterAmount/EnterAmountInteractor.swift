//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/19.
//

import ModernRIBs

protocol EnterAmountRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
  var listener: EnterAmountPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EnterAmountListener: AnyObject {
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()//카드 목록 보기
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
  
  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?
  
  private let dependency: EnterAmountInteractorDependency
  
  init(
    presenter: EnterAmountPresentable,
    dependency: EnterAmountInteractorDependency
  ) {
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didTapClose() {
    listener?.enterAmountDidTapClose()
  }
  
  func didTapPaymentMethod() {
    listener?.enterAmountDidTapPaymentMethod()
  }
  
  func didTapTopup(with amount: Double) {
    
  }
  
  
}
