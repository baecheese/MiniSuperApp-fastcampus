//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/10.
//

import ModernRIBs

protocol SuperPayDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
  var listener: SuperPayDashboardPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SuperPayDashboardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

// 추가되는 사항에 유연하게 대응하기 위해 init인자로 다 넣지 않고, 이렇게 protocol 내에서 추가한다.
protocol SuperPayDashboardInteractorDependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
  
  weak var router: SuperPayDashboardRouting?
  weak var listener: SuperPayDashboardListener?
  
  private let dependency: SuperPayDashboardInteractorDependency
  
  init(
    presenter: SuperPayDashboardPresentable,
    dependency: SuperPayDashboardInteractorDependency
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
}
