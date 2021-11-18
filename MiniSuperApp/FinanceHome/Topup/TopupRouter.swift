//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener {
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
  // this RIB does not own its own view, this protocol is conformed to by one of this
  // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  private var navigationControllerable: NavigationControllerable?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: AddPaymentMethodRouting?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    // TODO: Since this router does not own its view, it needs to cleanup the views
    // it may have added to the view hierarchy, when its interactor is deactivated.
  }
  
  func attachAddPaymentMethod() {
    guard nil == addPaymentMethodRouting else { return }
    addPaymentMethodRouting = addPaymentMethodBuildable.build(withListener: interactor)
    
  }
  
  func dettachAddPaymentMethod() {
    
  }
  
  private func presentInsideNavigation(_viewController: ViewControllable) {
    let navigation = NavigationControllerable(root: viewController)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllerable = navigation
    // topup은 자신의 뷰가 없음 - 부모가 보내준 view에 present할 것
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    guard nil != self.navigationControllerable else { return }
    viewController.dismiss(completion: completion)
  }
  
  
  // MARK: - Private
  
  private let viewController: ViewControllable
  
  
  
  
}
