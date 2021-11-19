//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs

/// topup riblet이 동작하기 위해 필요한 것들을 선언
/// topup riblet을 띄운 부모가 지정
protocol TopupDependency: Dependency {
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency {
  var cardOnFileRepository: CardOnFileRepository {
    dependency.cardOnFileRepository
  }
  fileprivate var topupBaseViewController: ViewControllable {
    dependency.topupBaseViewController
  }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TopupListener) -> TopupRouting {
    let component = TopupComponent(dependency: dependency)
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: addPaymentMethodBuilder,
      enterAmountBuildable: enterAmountBuilder
    )
  }
}
