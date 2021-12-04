import ModernRIBs
import FinanceRepository

protocol AppHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class AppHomeComponent: Component<AppHomeDependency>, TransportHomeDependency {
  
  var cardOnFileRepository: CardOnFileRepository {
    dependency.cardOnFileRepository
  }
  var superPayRepository: SuperPayRepository {
    dependency.superPayRepository
  }
}

// MARK: - Builder

protocol AppHomeBuildable: Buildable {
  func build(withListener listener: AppHomeListener) -> ViewableRouting
}

// Builder는 riblet 객체를 생성하는 역할을 한다.
final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {
  
  override init(dependency: AppHomeDependency) {
    super.init(dependency: dependency)
  }
  
  // riblet에 필요한 객체들을 생성
  func build(withListener listener: AppHomeListener) -> ViewableRouting {
    // 로직이 추가될 때, 로직을 수행할 때 필요한 객체를 담고 있는 바구니
    let component = AppHomeComponent(dependency: dependency)
    let viewController = AppHomeViewController()
    // 비즈니스 로직이 들어가는 riblet의 두뇌 역할
    let interactor = AppHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let transportHomeBuilder = TransportHomeBuilder(dependency: component)
    
    // router는 riblet간의 이동을 담당
    // riblet은 트리 구조로 부모-여러 자식 riblet 구조를 이룰 수 있음
    // router는 이 자식 riblet을 떼었다가 붙였다가 할 수 있도록 해줌
    return AppHomeRouter(
      interactor: interactor,
      viewController: viewController,
      transportHomeBuildable: transportHomeBuilder
    )
    // 이렇게 return된 router는 부모 riblet이 사용을 한다.
    // 현재 부모 riblet은 AppRoot riblet
  }
}
