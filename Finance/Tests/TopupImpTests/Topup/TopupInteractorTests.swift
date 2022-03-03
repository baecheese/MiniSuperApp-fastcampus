//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/03/03.
//

@testable import TopupImp
import XCTest

final class TopupInteractorTests: XCTestCase {
  
  private var sut: TopupInteractor!
  private var dependency: TopupInteractorDependency!
  
  override func setUp() {
    super.setUp()
    self.dependency = TopupInteractorDependencyMock()
    sut = TopupInteractor(dependency: self.dependency)
  }
  
}
