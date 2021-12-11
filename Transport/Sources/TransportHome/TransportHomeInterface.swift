//
//  File.swift
//  
//
//  Created by 배지영 on 2021/12/11.
//

import Foundation
import ModernRIBs

public protocol TransportHomeBuildable: Buildable {
  func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

public protocol TransportHomeListener: AnyObject {
  func transportHomeDidTapClose()
}
