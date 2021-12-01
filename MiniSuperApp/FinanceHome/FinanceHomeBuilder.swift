import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
  
  var cardOnFileRepository: CardOnFileRepository
  var superPayRepostitory: SuperPayRepository
  // 자식 riblet은 readonly 하도록
  var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepostitory.blance }
  var topupBaseViewController: ViewControllable
  
  init(
    dependency: FinanceHomeDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository,
    topupBaseViewController: ViewControllable
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepostitory = superPayRepository
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }
  
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let viewController = FinanceHomeViewController()
    
    // riblet의 component는 riblet에 필요한 객체를 담는 바구니
    // 이 component는 자식 riblet이 필요한 것도 담는다.
    // 때문에 자식인 SuperPayDashboardDependency를 부모 FinanceHomeComponent가 상속 받음
    let component = FinanceHomeComponent(
      dependency: dependency,
      cardOnFileRepository: CardOnFileRepositoryImp(),
      superPayRepository: SuperPayRepositoryImp(),
      topupBaseViewController: viewController
    )
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let topupBuilder = TopupBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashBoardBuildable: superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuilable: addPaymentMethodBuilder,
      topupBuilable: topupBuilder
    )
  }
}
