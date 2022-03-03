//
//  File.swift
//  
//
//  Created by 배지영 on 2021/12/11.
//

import Foundation
import FinanceHome
import ProfileHome
import AppHome
import FinanceRepository
import ModernRIBs
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp
import Network
import NetworkImp
import CombineSchedulers

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, TransportHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TopupDependency, AddPaymentMethodDependency {
  
  var mainQueue: AnySchedulerOf<DispatchQueue> { .main }
  
  var superPayRepository: SuperPayRepository
  var cardOnFileRepository: CardOnFileRepository
  
  lazy var transportHomeBuildable: TransportHomeBuildable = {
    return TransportHomeBuilder(dependency: self)
  }()
  
  lazy var topupBuildable: TopupBuildable = {
    return TopupBuilder(dependency: self)
  }()
  
  var topupBaseViewController: ViewControllable {
    return rootViewController.topupViewControllerable
  }
  
  private let rootViewController: ViewControllable
  
  lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
    return AddPaymentMethodBuilder(dependency: self)
  }()
  
  init(
    dependency: AppRootDependency,
    rootViewController: ViewControllable
  ) {
    let urlConfiguration = URLSessionConfiguration.ephemeral
    urlConfiguration.protocolClasses = [SuperAppURLProtocol.self]
    setupURLProtocol()
    
    let network = NetworkImp(session: URLSession(configuration: urlConfiguration))
    
    self.cardOnFileRepository = CardOnFileRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.cardOnFileRepository.fetch()
    
    self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}
