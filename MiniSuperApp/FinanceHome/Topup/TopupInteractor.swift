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
}

protocol TopupListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable {
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  private let dependency: TopupInteractorDependency
  
  init(
    dependency: TopupInteractorDependency
  ) {
    self.dependency = dependency
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
      // 카드 추가 화면
      router?.attachAddPaymentMethod()
    } else {
      // 금액 입력 화면
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
}
