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
  
  override func setUp() {
    super.setUp()
    
    self.interactor = TopupInteractableMock()
    self.viewController = ViewControllableMock()
    self.addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
    
    self.sut = TopupRouter(
      interactor: interactor,
      viewController: self.viewController,
      addPaymentMethodBuildable: addPaymentMethodBuildable,
      enterAmountBuildable: <#T##EnterAmountBuildable#>,
      cardOnFileBuidable: <#T##CardOnFileBuildable#>
    )
  }
  
}
