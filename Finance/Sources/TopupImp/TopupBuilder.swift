//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs
import SuperUI
import CombineUtil
import FinanceRepository
import AddPaymentMethod
import FinanceEntity
import Topup
import CombineSchedulers

/// topup riblet이 동작하기 위해 필요한 것들을 선언
/// topup riblet을 띄운 부모가 지정
public protocol TopupDependency: Dependency {
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
  var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, EnterAmountDependency, CardOnFileDependency {
  
  var mainQueue: AnySchedulerOf<DispatchQueue> { dependency.mainQueue  }
  
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> {
    paymentMethodStream
  }
  
  var cardOnFileRepository: CardOnFileRepository {
    dependency.cardOnFileRepository
  }
  
  fileprivate var topupBaseViewController: ViewControllable {
    dependency.topupBaseViewController
  }
  
  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init(
    dependency: TopupDependency,
    paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }
  
}

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  public override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TopupListener) -> Routing {
    let emptyPaymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
    let component = TopupComponent(dependency: dependency, paymentMethodStream: emptyPaymentMethodStream )
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: dependency.addPaymentMethodBuildable,
      enterAmountBuildable: enterAmountBuilder,
      cardOnFileBuidable: cardOnFileBuilder
    )
  }
}
