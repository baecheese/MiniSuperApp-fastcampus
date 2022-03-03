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
  private var dependency: TopupInteractorDependencyMock!
  private var lisenter: TopupLisenterMock!
  
  override func setUp() {
    super.setUp()
    self.dependency = TopupInteractorDependencyMock()
    self.lisenter = TopupLisenterMock()
    
    sut = TopupInteractor(dependency: self.dependency)
    sut.listener = self.lisenter
  }
  
}
