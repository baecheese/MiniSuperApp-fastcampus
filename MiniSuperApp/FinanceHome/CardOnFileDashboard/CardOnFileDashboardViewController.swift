//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/11.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {
  
  weak var listener: CardOnFileDashboardPresentableListener?
  
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
    label.text = "카드 및 계좌"
    return label
  }()
  
  private lazy var seeAllButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("전체보기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    // target에 self가 들어가야해서 lazy로
    button.addTarget(self, action: #selector(seeAllButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private let cardOnFileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .vertical
    stackView.spacing = 12.0
    return stackView
  }()
  
  private lazy var addMethodButton: AddPaymentMethodButton = {
    let button = AddPaymentMethodButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.roundCorners()
    button.backgroundColor = .gray
    button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    return button
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
    view.addSubview(cardOnFileStackView)
    
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(seeAllButton)
    
    cardOnFileStackView.addArrangedSubview(addMethodButton)
    
    NSLayoutConstraint.activate([
        headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
        headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
        headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        
        cardOnFileStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10.0),
        cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
        cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        addMethodButton.heightAnchor.constraint(equalToConstant: 60.0)
    ])
  }
  
  @objc func seeAllButtonDidTap() {
    
  }
  
  @objc func addButtonDidTap() {
    
  }
  
}
