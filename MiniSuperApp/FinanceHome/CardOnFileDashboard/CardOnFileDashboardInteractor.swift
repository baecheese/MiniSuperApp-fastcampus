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

protocol CardOnFileDashboardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
}
