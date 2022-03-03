//
//  TopupMock.swift
//  
//
//  Created by 배지영 on 2022/03/03.
//

import Foundation
import Topup

final class TopupLisenterMock: TopupListener {
  
  public var topupDidCloseCallCount = 0
  public func topupDidClose() {
    self.topupDidCloseCallCoount += 1
  }
  
  public var topupDidFinishCallCount = 0
  public func topupDidFinish() {
    self.topupDidFinishCallCoount += 1
  }
  
  public init() {
     
  }
}
