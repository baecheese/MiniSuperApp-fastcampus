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

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
  
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> {
    paymentMethodStream
  }
  
  var cardOnFileRepository: CardOnFileRepository {
    dependency.cardOnFileRepository
  }
  
  fileprivate var topupBaseViewController: ViewControllable {
    dependency.topupBaseViewController
  }
  
  private let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init(
    dependency: TopupDependency,
    paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
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
    let emptyPaymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
    let component = TopupComponent(dependency: dependency, paymentMethodStream: emptyPaymentMethodStream )
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: addPaymentMethodBuilder,
      enterAmountBuildable: enterAmountBuilder,
      cardOnFileBuidable: cardOnFileBuilder
    )
  }
}
