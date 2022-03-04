//
//  AddPaymentMethodTestSupport.swift
//  
//
//  Created by 배지영 on 2022/03/04.
//

import Foundation
import AddPaymentMethod
import ModernRIBs
import RIBsUtil
import RIBsTestSupport

public final class AddPaymentMethodBuildableMock: AddPaymentMethodBuildable {
  
  public var buildCallCount: Int = 0
  public var closeButtonType: DismissButtonType?
  
  public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
    self.buildCallCount += 1
    self.closeButtonType = closeButtonType
    return ViewableRoutingMock(
      interactable: Interactor(),
      viewControllable: ViewControllableMock()
    )
  }
  
}
