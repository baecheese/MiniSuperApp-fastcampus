//
//  PaymentViewModel.swift
//  
//
//  Created by 배지영 on 2021/12/04.
//

import UIKit
import FinanceEntity
import SuperUI

// 이런 뷰모델은 interactor와 viewcontroller 간의 쓰이는 작은 기능이기 때문에 package로 빼기보단 쓰이는 곳마다 파일을 만드는게 낫다.
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
