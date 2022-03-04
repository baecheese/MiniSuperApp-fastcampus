//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2022/03/03.
//

@testable import TopupImp
import XCTest
import RIBsTestSupport

final class TopupRouterTests: XCTestCase {
  
  private var sut: TopupRouter!
  private var interactor: TopupInteractableMock!
  private var viewController: ViewControllableMock
  
  override func setUp() {
    super.setUp()
    
    self.viewController = ViewControllableMock()
    
    self.sut = TopupRouter(
      interactor: interactor,
      viewController: self.viewController,
      addPaymentMethodBuildable: <#T##AddPaymentMethodBuildable#>,
      enterAmountBuildable: <#T##EnterAmountBuildable#>,
      cardOnFileBuidable: <#T##CardOnFileBuildable#>
    )
  }
  
}
