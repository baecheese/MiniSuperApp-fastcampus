import UIKit
import ModernRIBs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  private var launchRouter: LaunchRouting?
  private var urlHandler: URLHandler?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let result = AppRootBuilder(dependency: AppComponent()).build()
    // launchRouter는 앱 맨 처음 riblet에만 사용 (부모 riblet이 없어서)
    self.launchRouter = result.launchRouter
    self.urlHandler = result.urlHandler
    launchRouter?.launch(from: window)
    
    return true
  }
  
}

protocol URLHandler: AnyObject {
  func handle(_ url: URL)
}
