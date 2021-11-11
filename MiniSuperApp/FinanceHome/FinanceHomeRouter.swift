import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashBoardBuildable: SuperPayDashboardBuildable
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashBoardBuildable: SuperPayDashboardBuildable
  ) {
    self.superPayDashBoardBuildable = superPayDashBoardBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSuperPayDashBoard() {
    // 자식 riblet을 붙이려면 먼저 builder에 build 메서드를 호출해서 router를 받아와야 한다.
    // 자식 riblet의 listener는 비즈니스 로직을 담당하는 interactor가 된다.
    let router = superPayDashBoardBuildable.build(withListener: interactor)
    
    // 이 화면은 present할 것이 아닌 FinanceViewController에 subview로 넣어줄 것
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
  }
}
