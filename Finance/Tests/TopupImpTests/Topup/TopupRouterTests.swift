//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/03/03.
//

@testable import TopupImp
import XCTest
import RIBsTestSupport
import AddPaymentMethodTestSupport
import ModernRIBs

final class TopupRouterTests: XCTestCase {
  
  private var sut: TopupRouter!
  private var interactor: TopupInteractableMock!
  private var viewController: ViewControllableMock!
  private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
  private var enterAmountBuildable: EnterAmountBuildableMock!
  private var cardOnFileBuildable: CardOnFileBuildableMock!
  
  override func setUp() {
    super.setUp()
    self.interactor = TopupInteractableMock()
    self.viewController = ViewControllableMock()
    self.addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
    self.enterAmountBuildable = EnterAmountBuildableMock()
    self.cardOnFileBuildable = CardOnFileBuildableMock()
    
    self.sut = TopupRouter(
      interactor: self.interactor,
      viewController: self.viewController,
      addPaymentMethodBuildable: self.addPaymentMethodBuildable,
      enterAmountBuildable: self.enterAmountBuildable,
      cardOnFileBuidable: self.cardOnFileBuildable
    )
  }
  
  func testAttachAddPaymentMethod() {
    // given
    
    // when
    sut.attachAddPaymentMethod(closeButtonType: .close)
    
    // then
    XCTAssertEqual(addPaymentMethodBuildable.buildCallCount, 1)
    XCTAssertEqual(addPaymentMethodBuildable.closeButtonType, .close)
    XCTAssertEqual(viewController.presentCallCount, 1)
  }
  
  func testAttachEnterAmount() {
    // given
    let router = EnterAmountRoutingMock(
      interactable: Interactor(),
      viewControllable: ViewControllableMock()
    )
    
    var assginedListener: EnterAmountListener?
    enterAmountBuildable.buildHandler = { listener in
      assginedListener = listener
      return router
    }
    
    // when
    sut.attachEnterAmount()
    
    // then
    XCTAssertTrue(assginedListener === interactor)
    XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
  }
  
  func testAttachEnterAmountOnNavigation() {
    // given
    let router = EnterAmountRoutingMock(
      interactable: Interactor(),
      viewControllable: ViewControllableMock()
    )
    
    var assginedListener: EnterAmountListener?
    enterAmountBuildable.buildHandler = { listener in
      assginedListener = listener
      return router
    }
    
    // when
    sut.attachAddPaymentMethod(closeButtonType: .close)//다른 페이지에 있다가
    sut.attachEnterAmount()// 들어갔을 때
    
    // then
    XCTAssertTrue(assginedListener === interactor)
    XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
    XCTAssertEqual(sut.children.count, 1)
  }
  
}
