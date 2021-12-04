//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/16.
//

import UIKit

// delegate이기 때문에 weak로 바꿔야해서 AnyObject를 받도록 했다.
public protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  
  public weak var delegate: AdaptivePresentationControllerDelegate?
  
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
  
}
