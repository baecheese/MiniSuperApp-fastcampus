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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, TransportHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TopupDependency  {
  
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
  
  
  init(
    dependency: AppRootDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository,
    rootViewController: ViewControllable
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepository = superPayRepository
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}
