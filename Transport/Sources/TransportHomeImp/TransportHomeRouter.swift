import ModernRIBs
import Topup
import TransportHome

protocol TransportHomeInteractable: Interactable, TopupListener {
  var router: TransportHomeRouting? { get set }
  var listener: TransportHomeListener? { get set }
}

protocol TransportHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TransportHomeRouter: ViewableRouter<TransportHomeInteractable, TransportHomeViewControllable>, TransportHomeRouting {
  
  let topupBuilable: TopupBuildable
  var topupRouting: Routing?
  
  init(
    interactor: TransportHomeInteractable,
    viewController: TransportHomeViewControllable,
    topupBuilable: TopupBuildable
  ) {
    self.topupBuilable = topupBuilable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attatchTopup() {
    guard nil == topupRouting else { return }
    let router = topupBuilable.build(withListener: interactor)
    self.topupRouting = router
    attachChild(router)
  }
  
  func dettatchTopup() {
    guard let topupRouter = topupRouting else { return }
    detachChild(topupRouter)
    self.topupRouting = nil
  }
  
  
}
