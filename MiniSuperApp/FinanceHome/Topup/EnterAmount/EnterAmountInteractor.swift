//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/19.
//

import Foundation
import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
  var listener: EnterAmountPresentableListener? { get set }
  
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
  func startLoading()
  func stopLoading()
}

protocol EnterAmountListener: AnyObject {
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()//카드 목록 보기
  func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
  var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
  
  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?
  
  private let dependency: EnterAmountInteractorDependency
  
  private var cancelables: Set<AnyCancellable>
  
  init(
    presenter: EnterAmountPresentable,
    dependency: EnterAmountInteractorDependency
  ) {
    self.dependency = dependency
    self.cancelables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
      self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
    }.store(in: &cancelables)
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
    presenter.startLoading()
    
    dependency.superPayRepository.topup(
      amount: amount,
      paymentId: dependency.selectedPaymentMethod.value.id
    )
      // 위의 메소드가 background thread에서 돌아서 결과값은 main thread에서 받아야함 (stopLoading UI update 때문)
      .receive(on: DispatchQueue.main)
      .sink(
      receiveCompletion: { [weak self] _ in
        self?.presenter.stopLoading()
      },
      receiveValue: { [weak self] _ in
        self?.listener?.enterAmountDidFinishTopup()
      }
    ).store(in: &cancelables)
  }
  
  
}
