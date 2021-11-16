//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import ModernRIBs

/// topup riblet이 동작하기 위해 필요한 것들을 선언
/// topup riblet을 띄운 부모가 지정
protocol TopupDependency: Dependency {
  var topupBaseViewController: ViewControllable { get }
}

final class TopupComponent: Component<TopupDependency> {

    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor()
        interactor.listener = listener
        return TopupRouter(interactor: interactor, viewController: component.topupBaseViewController)
    }
}
