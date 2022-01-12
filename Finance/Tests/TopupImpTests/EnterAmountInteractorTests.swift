//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/01/12.
//

@testable import TopupImp
import XCTest

final class EnterAmountInteractorTests: XCTestCase {
  
  /// systemUnderTest - sut
  private var sut: EnterAmountInteractor!
  private var presenter: EnterAmountPresentableMock!
  
  override func setUp() {
    super.setUp()
    // 실제 앱에서는 presenter에는 viewController, dependency에는 component
    sut = EnterAmountInteractor(
      presenter: self.presenter,
      dependency: <#T##EnterAmountInteractorDependency#>
    )
  }
  
  // MARK: - Tests
  
  func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
    // This is an example of an interactor test case.
    // Test your interactor binds observables and sends messages to router or listener.
  }
}
