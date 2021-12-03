//
//  RIBs+Util.swift
//  
//
//  Created by 배지영 on 2021/12/03.
//

import Foundation

public enum DismissButtonType {
  case back, close
  
  public var iconSystemName: String {
    switch self {
    case .back:
      return "chevron.backward"
    case .close:
      return "xmark"
    }
  }
}
