import ModernRIBs
import RIBsUtil

protocol AppRootInteractable: Interactable,
                              AppHomeListener,
                              FinanceHomeListener,
                              ProfileHomeListener {
  var router: AppRootRouting? { get set }
  var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
  func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
  
  private let appHome: AppHomeBuildable
  private let financeHome: FinanceHomeBuildable
  private let profileHome: ProfileHomeBuildable
  
  private var appHomeRouting: ViewableRouting?
  private var financeHomeRouting: ViewableRouting?
  private var profileHomeRouting: ViewableRouting?
  
  init(
    interactor: AppRootInteractable,
    viewController: AppRootViewControllable,
    appHome: AppHomeBuildable,
    financeHome: FinanceHomeBuildable,
    profileHome: ProfileHomeBuildable
  ) {
    self.appHome = appHome
    self.financeHome = financeHome
    self.profileHome = profileHome
    
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTabs() {
    // 자식 builder에 build 메서드들을 호출해서 return된 router를 받는다
    let appHomeRouting = appHome.build(withListener: interactor)
    let financeHomeRouting = financeHome.build(withListener: interactor)
    let profileHomeRouting = profileHome.build(withListener: interactor)
    
    // 부모 riblet이 자식 riblet을 받아서 하는 것
    // 1. attachChild를 해줌 - ribs framework에 있는 메서드다. ribs tree를 만들어서 각 riblet들의 reference를 유지하고, interactor의 lifecycle 관련 메서드를 호출하는 작업을 한다.
    attachChild(appHomeRouting)
    attachChild(financeHomeRouting)
    attachChild(profileHomeRouting)
    
    // 2. viewcontroller를 띄운다.
    // riblet의 view는 router의 viewControllerable을 통해 가져올 수 있다.
    // viewControllerable은 viewController를 한번 감싼 객체로 UIKit을 직접 import하지 않고 쓰기 위해 만들어짐 => 자세한 내용은 2부에서..
    let viewControllers = [
      NavigationControllerable(root: appHomeRouting.viewControllable),
      NavigationControllerable(root: financeHomeRouting.viewControllable),
      profileHomeRouting.viewControllable
    ]
      
    // 각각의 router로부터 viewControllable을 받아와서 tabBarController에 세팅
    viewController.setViewControllers(viewControllers)
  }
}
