//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/10.
//

import ModernRIBs
import Combine
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
  var listener: SuperPayDashboardPresentableListener? { get set }
  
  func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
  func superPayDashboardDidTapTopup()
}

// 추가되는 사항에 유연하게 대응하기 위해 init인자로 다 넣지 않고, 이렇게 protocol 내에서 추가한다.
protocol SuperPayDashboardInteractorDependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
  
  weak var router: SuperPayDashboardRouting?
  weak var listener: SuperPayDashboardListener?
  
  private let dependency: SuperPayDashboardInteractorDependency
  
  private var cancelables: Set<AnyCancellable> // ??
  
  init(
    presenter: SuperPayDashboardPresentable,
    dependency: SuperPayDashboardInteractorDependency
  ) {
    self.dependency = dependency
    self.cancelables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    dependency.balance
      // superpayRepository에서 blanceSubject.send 해주는 부분이 background thread라서 main thread로 돌려서 받을 것
      .receive(on: DispatchQueue.main)
      .sink { [weak self] balance in
      self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map ({
        self?.presenter.updateBalance($0)
      })
    }.store(in: &cancelables)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func topupButtonDidTap() {
    listener?.superPayDashboardDidTapTopup()
  }
}
