//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/03/03.
//

@testable import TopupImp
import XCTest
import TopupTestSupport

final class TopupInteractorTests: XCTestCase {
  
  private var sut: TopupInteractor!
  private var dependency: TopupDependencyMock!
  private var lisenter: TopupLisenterMock!
  private var router: TopupRoutingMock!
  
  override func setUp() {
    super.setUp()
    self.dependency = TopupDependencyMock()
    self.lisenter = TopupLisenterMock()
    
    let interactor = TopupInteractor(dependency: self.dependency)
    self.router = TopupRoutingMock(interactable: interactor)
    
    interactor.listener = self.lisenter
    interactor.router = self.router
    self.sut = interactor
  }
  
}
