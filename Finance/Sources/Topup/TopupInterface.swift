//
//  TopupInterface.swift
//  
//
//  Created by 배지영 on 2021/12/16.
//

import Foundation
import ModernRIBs

// MARK: - Builder

public protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}
