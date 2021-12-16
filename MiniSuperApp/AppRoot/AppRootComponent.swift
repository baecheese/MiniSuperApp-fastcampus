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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, TransportHomeDependency, FinanceHomeDependency, ProfileHomeDependency  {
  
  var superPayRepository: SuperPayRepository
  var cardOnFileRepository: CardOnFileRepository
  
  lazy var transportHomeBuildable: TransportHomeBuildable = {
    return TransportHomeBuilder(dependency: self)
  }()
  
  init(
    dependency: AppRootDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepository = superPayRepository
    super.init(dependency: dependency)
  }
}
