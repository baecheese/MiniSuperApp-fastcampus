//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/15.
//

import UIKit
import FinanceEntity
import SuperUI

struct PaymentMethodViewModel {
  
  let name: String
  let digits: String
  let color: UIColor // backend에서 보통 hex string으로 내려준다
  
  init(_ paymentMethod: PaymentMethod) {
    name = paymentMethod.name
    digits = paymentMethod.digits
    color = UIColor(hex: paymentMethod.color) ?? .systemGray2
  }
  
}
