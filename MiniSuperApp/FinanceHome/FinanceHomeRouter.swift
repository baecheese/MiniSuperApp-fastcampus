import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashBoardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashBoardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuilable: AddPaymentMethodBuildable
  ) {
    self.superPayDashBoardBuildable = superPayDashBoardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuilable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSuperPayDashBoard() {
    guard nil == superPayRouting else { return } // 같은 자식 riblet을 붙이지 않게 하기 위한 방어로직
    // 자식 riblet을 붙이려면 먼저 builder에 build 메서드를 호출해서 router를 받아와야 한다.
    // 자식 riblet의 listener는 비즈니스 로직을 담당하는 interactor가 된다.
    let router = superPayDashBoardBuildable.build(withListener: interactor)
    
    // 이 화면은 present할 것이 아닌 FinanceViewController에 subview로 넣어줄 것
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.superPayRouting = router
    // 자식 riblet을 붙임
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    guard nil == cardOnFileRouting else { return }
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.cardOnFileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    guard nil == addPaymentMethodRouting else { return }
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    
  }
  
  func dettachAddPaymentMethod() {
    <#code#>
  }
  
}
