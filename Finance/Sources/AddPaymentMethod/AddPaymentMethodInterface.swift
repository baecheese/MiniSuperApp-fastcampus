//
//  AddPaymentMethodInterface.swift
//  
//
//  Created by 배지영 on 2021/12/16.
//

import Foundation
import ModernRIBs
import FinanceEntity
import RIBsUtil

// MARK: - Builder

public protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject {
  func addPaymentMethodDidTapClose()
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}
