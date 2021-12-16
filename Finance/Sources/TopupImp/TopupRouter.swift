//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs
import SuperUI
import RIBsUtil
import FinanceEntity
import AddPaymentMethod

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
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
  private var addPaymentMethodRouting: Routing?
  
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: Routing?
  
  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: Routing?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    enterAmountBuildable: EnterAmountBuildable,
    cardOnFileBuidable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuidable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  /// 뷰가 있는 riblet은 close 시, 떠있던 화면을 dimiss시키는 건 부모가 하는 역할
  /// viewless riblet은 부모가 직접 띄운 창이 아니기 때문에 자신의 역할이 끝났을 때 스스로 view를 dismiss 시켜줘야 한다.
  /// ineratcor의 willResignActive()에서 불림
  func cleanupViews() {
    guard nil != viewController.uiviewController.presentationController,
          nil != navigationControllerable else { return }
    navigationControllerable?.dismiss(completion: nil)
  }
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
    guard nil == addPaymentMethodRouting else { return }
    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
    if let navigation = navigationControllerable {
      navigation.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func dettachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    navigationControllerable?.popViewController(animated: true)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  
  func attachEnterAmount() {
    guard nil == enterAmountRouting else { return }
    let router = enterAmountBuildable.build(withListener: interactor)
    
    if let navigation = navigationControllerable {
      // 네비게이션이 있으면, 기존에 있던 나머지 페이지 리셋 후 push
      navigation.setViewControllers([router.viewControllable])
      resetChildRouting()
    } else {// 네비게이션이 없을 땐, 바로 충전 페이지 present
      presentInsideNavigation(router.viewControllable)
    }
    
    attachChild(router)
    enterAmountRouting = router
  }
  
  func dettachEnterAmount() {
    guard let router = enterAmountRouting else { return }
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    guard nil == cardOnFileRouting else { return }
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
    attachChild(router)
    navigationControllerable?.pushViewController(router.viewControllable, animated: true)
    cardOnFileRouting = router
  }
  
  func dettachCardOnFile() {
    guard let router = cardOnFileRouting else { return }
    navigationControllerable?.popViewController(animated: true)
    detachChild(router)
    cardOnFileRouting = nil
  }
  
  func popToRoot() {
    navigationControllerable?.popToRoot(animated: true)
    resetChildRouting()
  }
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllerable = navigation
    // topup은 자신의 뷰가 없음 - 부모가 보내준 view에 present할 것
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    guard nil != self.navigationControllerable else { return }
    viewController.dismiss(completion: completion)
  }
  
  private func resetChildRouting() {
    if let addPaymentMethodRouter = addPaymentMethodRouting {
      detachChild(addPaymentMethodRouter)
      self.addPaymentMethodRouting = nil
    }
    if let cardOnFileRouter = cardOnFileRouting {
      detachChild(cardOnFileRouter)
      self.cardOnFileRouting = nil
    }
  }
  
  
  // MARK: - Private
  
  private let viewController: ViewControllable
  
  
  
  
}
