import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashBoard()
  func attachCardOnFileDashboard()
  func attachAddPaymentMethod()
  func dettachAddPaymentMethod()
  func attachTopup()
  func dettachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

// MVC에서는 비즈니스로직이 viewDidload에 들어가지만, ribs에서는 ViewController는 그냥 View로만 취급하고, Interactor가 비즈니스 로직이다.
// UIAdaptivePresentationControllerDelegate를 직접 상속받는 대신에 어뎁터로 감싸서 쓸어내려서 dismiss하기 액션을 콜백 받을 수 있도록 한다.
final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: FinanceHomePresentable) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    router?.attachSuperPayDashBoard()
    router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    router?.dettachAddPaymentMethod()
  }
  
  // MARK:- CardOnFileDashboardListsenr
  func cardOnFileDashboardDidTapAddPaymentMethod() {
    router?.attachAddPaymentMethod()
  }
  
  // MARK:- AddPaymentMethodListener
  func addPaymentMethodDidTapClose() {
    router?.dettachAddPaymentMethod()
  }
  
  // 카드 추가 성공 시, 화면 dettach
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    router?.dettachAddPaymentMethod()
  }
  
  func superPayDashboardDidTapTopup() {
    router?.attachTopup()
  }
  
  func topupDidClose() {
    router?.dettachTopup()
  }
  
  func topupDidFinish() {
    router?.dettachTopup()
  }
  
}
