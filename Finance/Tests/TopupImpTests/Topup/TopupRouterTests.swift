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

final class TopupRouterTests: XCTestCase {
  
  private var sut: TopupRouter!
  private var interactor: TopupInteractableMock!
  private var viewController: ViewControllableMock
  private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
  private var enterAmountBuildable: EnterAmountBuildableMock!
  
  override func setUp() {
    super.setUp()
    
    self.interactor = TopupInteractableMock()
    self.viewController = ViewControllableMock()
    self.addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
    self.enterAmountBuildable = EnterAmountBuildableMock()
    
    self.sut = TopupRouter(
      interactor: self.interactor,
      viewController: self.viewController,
      addPaymentMethodBuildable: self.addPaymentMethodBuildable,
      enterAmountBuildable: self.EnterAmountRouterTests,
      cardOnFileBuidable: <#T##CardOnFileBuildable#>
    )
  }
  
}
