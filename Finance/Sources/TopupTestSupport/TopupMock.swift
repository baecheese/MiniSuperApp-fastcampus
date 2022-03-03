//
//  TopupMock.swift
//  
//
//  Created by 배지영 on 2022/03/03.
//

import Foundation
import Topup

final public class TopupLisenterMock: TopupListener {
  
  public var topupDidCloseCallCount = 0
  public func topupDidClose() {
    self.topupDidCloseCallCount += 1
  }
  
  public var topupDidFinishCallCount = 0
  public func topupDidFinish() {
    self.topupDidFinishCallCount += 1
  }
  
  public init() {
     
  }
}
