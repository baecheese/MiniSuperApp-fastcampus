//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/10.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
  func topupButtonDidTap()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {
  
  weak var listener: SuperPayDashboardPresentableListener?
  
  private let headerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22.0, weight: .semibold)
    label.text = "슈퍼페이 잔고"
    return label
  }()
  
  private lazy var topupButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("충전하기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    // target에 self가 들어가야해서 lazy로
    button.addTarget(self, action: #selector(topupButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16.0
    view.layer.cornerCurve = .continuous
    view.backgroundColor = .systemIndigo
    return view
  }()
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22.0, weight: .semibold)
    label.text = "원"
    label.textColor = .white
    return label
  }()
  
  private let balanceAmountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22.0, weight: .semibold)
    label.textColor = .white
    // 변화가 잦고, 앱 여러 곳에서 사용해야하는 "잔액" 과 같은 컨텐츠는 Stream을 이용하는 것이 좋다.
    label.text = "10,000"
    return label
  }()
  
  private let balanceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    stackView.spacing = 4.0
    return stackView
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  private func setupViews() {
    view.addSubview(headerStackView)
    view.addSubview(cardView)
    
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(topupButton)
    
    cardView.addSubview(balanceStackView)
    balanceStackView.addArrangedSubview(balanceAmountLabel)
    balanceStackView.addArrangedSubview(currencyLabel)
    
    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
      
      cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10.0),
      cardView.heightAnchor.constraint(equalToConstant: 180.0),
      cardView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor, constant:  0.0),
      cardView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor, constant: 0.0),
      cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
      
      balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
      balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
      
    ])
  }
  
  @objc func topupButtonDidTap() {
    listener?.topupButtonDidTap()
  }
  
  func updateBalance(_ balance: String) {
    balanceAmountLabel.text = balance
  }
  
  
}
