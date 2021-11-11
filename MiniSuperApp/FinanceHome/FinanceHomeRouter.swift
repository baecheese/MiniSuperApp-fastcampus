import ModernRIBs

protocol FinanceHomeInteractable: Interactable {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
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
}
