import Foundation
import ModernRIBs

protocol AppRootRouting: ViewableRouting {
  func attachTabs()
}

protocol AppRootPresentable: Presentable {
  var listener: AppRootPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppRootListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener, URLHandler {
  
  weak var router: AppRootRouting?
  weak var listener: AppRootListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: AppRootPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  // MVC의 ViewDidLoad와 비슷한 역할
  // riblet이 처음 tree에 붙여질 때, 부모에게 acttach가 되어 활성화될 때 didBecomeActive이 불린다.
  override func didBecomeActive() {
    super.didBecomeActive()
    // 앱이 로딩이 되고, 앱 root를 붙이자마자 router에 attachTabs가 불려서 앱의 tab들을 만들어주는 것
    router?.attachTabs()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func handle(_ url: URL) {
    
  }
}
