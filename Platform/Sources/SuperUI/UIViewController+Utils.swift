//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/19.
//

import UIKit
import RIBsUtil

public extension UIViewController {
  
  func setupNavigationItem(
    with buttonType: DismissButtonType,
    target: Any?,
    action: Selector?
  ) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(
        systemName: buttonType.iconSystemName,
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0, weight: .semibold)
      ),
      style: .plain,
      target: target,
      action: action
    )
  }
  
}
