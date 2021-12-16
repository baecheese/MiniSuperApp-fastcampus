import ModernRIBs
import UIKit
import FinanceRepository
import FinanceHome
import AppHome
import ProfileHome

protocol AppRootDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
  
  override init(dependency: AppRootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
    // AppRoot의 ViewController
    let tabBar = RootTabBarController()
    
    let interactor = AppRootInteractor(presenter: tabBar)
    
    let component = AppRootComponent(
      dependency: dependency,
      rootViewController: tabBar
    )
    
    // 이 앱의 부모 riblet인 AppRoot riblet
    // 아래 3가지 자식 riblet을 붙이기 위해 Builder를 생성
    let appHome = AppHomeBuilder(dependency: component)
    let financeHome = FinanceHomeBuilder(dependency: component)
    let profileHome = ProfileHomeBuilder(dependency: component)
      
    // 자식 riblet을 붙이는건 router가 함
    let router = AppRootRouter(
      interactor: interactor,
      viewController: tabBar,
      appHome: appHome,
      financeHome: financeHome,
      profileHome: profileHome
    )
    
    return (router, interactor)
  }
}
