//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/01/12.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {
  
  /// systemUnderTest - sut
  private var sut: EnterAmountInteractor!
  private var presenter: EnterAmountPresentableMock!
  private var dependency: EnterAmountDependencyMock!
  private var listener: EnterAmountListenerMock!
  
  var repository: SuperPayRepositoryMock {
    dependency.superPayRepository as! SuperPayRepositoryMock
  }
  
  override func setUp() {
    super.setUp()
    // 실제 앱에서는 presenter에는 viewController, dependency에는 component
    
    self.presenter = EnterAmountPresentableMock()
    self.dependency = EnterAmountDependencyMock()
    // rounter는 쓰는 곳이 없어서 init 안함
    self.listener = EnterAmountListenerMock()
    
    sut = EnterAmountInteractor(
      presenter: self.presenter,
      dependency: self.dependency 
    )
    sut.listener = self.listener
  }
  
  // MARK: - Tests
  
  // didBecomeActive
  func testActive() {
    // give
    let paymentMethod = PaymentMethod(
      id: "id_0",
      name: "name_0",
      digits: "9999",
      color: "#13ABE8FF",
      isPrimary: false
    )
    dependency.selectedPaymentMoethodSubject.send(paymentMethod)
    
    // when
    sut.activate()
    
    // then
    XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
    /// name = "\(paymentMethod.name) \(paymentMethod.digits)" 확인
    XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 9999")
    XCTAssertNotNil(presenter.updateSelectedPaymentMethodViewModel?.image)
  }
  
  // didTapTopup
  func testTopupWithVaildAmount() {
    // give
    let paymentMethod = PaymentMethod(
      id: "id_0",
      name: "name_0",
      digits: "9999",
      color: "#13ABE8FF",
      isPrimary: false
    )
    dependency.selectedPaymentMoethodSubject.send(paymentMethod)
    
    // when
    sut.didTapTopup(with: 1_000_000)
    
    // then
    XCTAssertEqual(presenter.startLoadingCount, 1)
    XCTAssertEqual(presenter.stopLoadingCount, 1)
    XCTAssertEqual(repository.topupCallCount, 1)
    XCTAssertEqual(repository.paymentMethodID, "id_0")
    XCTAssertEqual(repository.topupAmount, 1_000_000)
    XCTAssertEqual(listener.enterAmountDidFinishTopupCount, 1)
  }
  
  func testTopupWithFailure() {
    // give
    let paymentMethod = PaymentMethod(
      id: "id_0",
      name: "name_0",
      digits: "9999",
      color: "#13ABE8FF",
      isPrimary: false
    )
    dependency.selectedPaymentMoethodSubject.send(paymentMethod)
    // 실패할 경우로 세팅
    repository.shouldTopupSucceed = false
    
    // when
    sut.didTapTopup(with: 1_000_000)
    
    // then
    XCTAssertEqual(presenter.startLoadingCount, 1)
    XCTAssertEqual(presenter.stopLoadingCount, 1)
    XCTAssertEqual(listener.enterAmountDidFinishTopupCount, 0)//fail 이기 때문이 0이어야 함
  }
  
  func testDidTapClose() {
    // give
    
    // when
    sut.didTapClose()
    
    // then
    XCTAssertEqual(listener.enterAmountDidTapCloseCount, 1)
  }
  
  func testDidTapPaymentMethod() {
    // give
    
    // when
    sut.didTapPaymentMethod()
    
    // then
    XCTAssertEqual(listener.enterAmountDidTapPaymentMethodCount, 1)
  }
  
}
