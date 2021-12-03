//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/15.
//

import ModernRIBs
import UIKit
import RIBsUtil

protocol AddPaymentMethodPresentableListener: AnyObject {
  func didTapClose()
  func didTapConfirm(with number: String, cvc: String, expiration: String)
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {
  
  weak var listener: AddPaymentMethodPresentableListener?
  
  private let stackView: UIStackView = {
    let stackview = UIStackView()
    stackview.translatesAutoresizingMaskIntoConstraints = false
    stackview.axis = .horizontal
    stackview.alignment = .center
    stackview.distribution = .fillEqually
    stackview.spacing = 14.0
    return stackview
  }()
  
  private let cardNumberTextfiled: UITextField = {
    let textfield = makeTextfield()
    textfield.placeholder = "카드 번호"
    return textfield
  }()
  
  private let securityTextfield: UITextField = {
    let textfield = makeTextfield()
    textfield.placeholder = "CVC"
    return textfield
  }()
  
  private let expirationTextfield: UITextField = {
    let textfield = makeTextfield()
    textfield.placeholder = "유효기간"
    return textfield
  }()
  
  private lazy var addCardButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .primaryRed
    button.roundCorners()
    button.setTitle("추가하기", for: .normal)
    button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
    return button
  }()
  
  private static func makeTextfield() -> UITextField {
    let textfield = UITextField()
    textfield.translatesAutoresizingMaskIntoConstraints = false
    textfield.backgroundColor = .white
    textfield.borderStyle = .roundedRect
    textfield.keyboardType = .numberPad
    return textfield
  }
  
  init(closeButtonType: DismissButtonType) {
    super.init(nibName: nil, bundle: nil)
    setupViews()
    setupNavigationItem(with: closeButtonType, target: self, action: #selector(didTapClose))
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
    setupNavigationItem(with: .close, target: self, action: #selector(didTapClose))
  }
  
  private func setupViews() {
    title = "카드 추가"
    
    view.backgroundColor = .backgroundColor
    view.addSubview(cardNumberTextfiled)
    view.addSubview(stackView)
    view.addSubview(addCardButton)
    
    stackView.addArrangedSubview(securityTextfield)
    stackView.addArrangedSubview(expirationTextfield)
    
    NSLayoutConstraint.activate([
      cardNumberTextfiled.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
      cardNumberTextfiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      cardNumberTextfiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      
      cardNumberTextfiled.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20.0),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      
      stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20.0),
      addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      
      cardNumberTextfiled.heightAnchor.constraint(equalToConstant: 60.0),
      securityTextfield.heightAnchor.constraint(equalToConstant: 60.0),
      expirationTextfield.heightAnchor.constraint(equalToConstant: 60.0),
      addCardButton.heightAnchor.constraint(equalToConstant: 60.0)
    ])
  }
  
  @objc func didTapAddCard() {
    guard let number = cardNumberTextfiled.text,
          let cvc = securityTextfield.text,
          let expiration = expirationTextfield.text else { return }
    listener?.didTapConfirm(with: number, cvc: cvc, expiration: expiration)
  }
  
  @objc func didTapClose() {
    // 화면을 닫는 액션은 routing 역할이기 때문에 listener에게 전달
    listener?.didTapClose()
  }
  
}
