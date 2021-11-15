//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/11.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
  var listener: CardOnFileDashboardPresentableListener? { get set }
  
  func update(with viewModels: [PaymentMethodViewModel])
}

// 부모 riblet에게 어떤 이벤트가 발생했다는 것을 알릴 수 있다.
protocol CardOnFileDashboardListener: AnyObject {
  func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {
  
  weak var router: CardOnFileDashboardRouting?
  weak var listener: CardOnFileDashboardListener?
  
  private let dependency: CardOnFileDashboardInteractorDependency
  
  private var cancellables: Set<AnyCancellable>
  
  init(
    presenter: CardOnFileDashboardPresentable,
    dependency: CardOnFileDashboardInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.cardOnFileRepository.cardOnFile.sink { methods in
      let vieWModel = methods
        .prefix(5)//최대 5개
        .map(PaymentMethodViewModel.init)
      self.presenter.update(with: vieWModel)
    }.store(in: &cancellables)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // didBecomeActive 내에 로직에서 캡쳐되어있던 method 로직들이 Resign 될 때 모두 사라질 수 있도록 한다.
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
  }
  
  func didTapAddPaymentMethod() {
    // 강사는 CardOnFileDashboard riblet 보다 부모의 riblet에서 화면이 불리는 것을 선택
    // riblet 끼리의 통신은 interactor로 한다.
    listener?.cardOnFileDashboardDidTapAddPaymentMethod()
  }
  
}
