//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/03/03.
//

@testable import TopupImp
import XCTest
import TopupTestSupport
import FinanceEntity
import FinanceRepositoryTestSupport

final class TopupInteractorTests: XCTestCase {
  
  private var sut: TopupInteractor!
  private var dependency: TopupDependencyMock!
  private var lisenter: TopupLisenterMock!
  private var router: TopupRoutingMock!
  
  private var cardOnFileRepository: CardOnFileRepositoryMock {
    dependency.cardOnFileRepository as! CardOnFileRepositoryMock
  }
  
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
  
  func testActivate() {
    // given
    let cards = [
      PaymentMethod(
        id: "0",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      )
    ]
    cardOnFileRepository.cardOnFileSubject.send(cards)
    
    // when
    sut.activate()
    
    // then
    XCTAssertEqual(dependency.paymentMethodStream.value.name, "zero")
    XCTAssertEqual(router.attachEnterAmountCallCount, 1)
  }
  
  func testActivateWithoutCard() {
    // given
    cardOnFileRepository.cardOnFileSubject.send([])
    
    // when
    sut.activate()
    
    // then
    XCTAssertEqual(router.attachAddPaymentMethodCallCount, 1)
    XCTAssertEqual(router.attachAddPaymentMethodCloseButtonType, .close)
  }
 
  func testDidAddCardWithCard() {
    // given
    let cards = [
      PaymentMethod(
        id: "0",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      )
    ]
    cardOnFileRepository.cardOnFileSubject.send(cards)
    
    let newCard =
    PaymentMethod(
      id: "new_card_id",
      name: "test",
      digits: "0000",
      color: "",
      isPrimary: false
    )
    
    // when
    sut.activate() // isEnterAmount 값 세팅을 위해 먼저 실행
    sut.addPaymentMethodDidAddCard(paymentMethod: newCard )
    
    // then
    XCTAssertEqual(router.popToRootCallCount, 1)
    XCTAssertEqual(dependency.paymentMethodStream.value.id, newCard.id)
  }
  
  func testDidAddCardWithoutCard() {
    // given
    cardOnFileRepository.cardOnFileSubject.send([])
    
    let newCard =
    PaymentMethod(
      id: "new_card_id",
      name: "test",
      digits: "0000",
      color: "",
      isPrimary: false
    )
    
    // when
    sut.activate() // isEnterAmount 값 세팅을 위해 먼저 실행
    sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
    
    // then
    XCTAssertEqual(router.attachEnterAmountCallCount, 1)
    XCTAssertEqual(dependency.paymentMethodStream.value.id, newCard.id)
  }
  
  func testAddPaymentMethodDidAddCardFromEnterAmount() {
    // given
    let cards = [
      PaymentMethod(
        id: "0",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      )
    ]
    cardOnFileRepository.cardOnFileSubject.send(cards)
    
    // when
    sut.activate()
    sut.addPaymentMethodDidTapClose()
    
    // then
    XCTAssertEqual(router.dettachAddPaymentMethodCallCount, 1)
  }
  
  func testAddPaymentMethodDidAddCard() {
    // given
    cardOnFileRepository.cardOnFileSubject.send([])
    
    // when
    sut.activate()
    sut.addPaymentMethodDidTapClose()
    
    // then
    XCTAssertEqual(router.dettachAddPaymentMethodCallCount, 1)
    XCTAssertEqual(lisenter.topupDidCloseCallCount, 1)
  }
  
  func testDidSelectCard() {
    // given
    let cards = [
      PaymentMethod(
        id: "0",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      ),
      PaymentMethod(
        id: "1",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      )
    ]
    cardOnFileRepository.cardOnFileSubject.send(cards)
    
    // when
    sut.cardOnFileDidSelect(at: 0)
    
    // then
    XCTAssertEqual(dependency.paymentMethodStream.value.id, "0")
    XCTAssertEqual(router.dettachCardOnFileCallCount, 1)
  }
  
  /// paymentMethods[safe: index] 잘 동작하고 있는지 확인
  func testDidSelectCardWithInvaildIndex() {
    // given
    let cards = [
      PaymentMethod(
        id: "0",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      ),
      PaymentMethod(
        id: "1",
        name: "zero",
        digits: "123",
        color: "",
        isPrimary: false
      )
    ]
    cardOnFileRepository.cardOnFileSubject.send(cards)
    
    // when
    sut.cardOnFileDidSelect(at: 100)
    
    // then
    XCTAssertEqual(dependency.paymentMethodStream.value.id, "")
    XCTAssertEqual(router.dettachCardOnFileCallCount, 1)
  }
   
}
