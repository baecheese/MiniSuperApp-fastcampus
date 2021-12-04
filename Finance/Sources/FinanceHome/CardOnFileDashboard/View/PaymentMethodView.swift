//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/12.
//

import UIKit

final class PaymentMethodView: UIView {
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 18.0, weight: .semibold)
    label.textColor = .white
    label.text = "테스트 은행"
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15.0, weight: .regular)
    label.textColor = .white
    label.text = "123***"
    return label
  }()
  
  
  init(viewModel: PaymentMethodViewModel) {
    super.init(frame: .zero)
    
    setupView()
    
    nameLabel.text = viewModel.name
    subtitleLabel.text = viewModel.digits
    backgroundColor = viewModel.color
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    addSubview(nameLabel)
    addSubview(subtitleLabel)
    backgroundColor = .systemIndigo
    
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
      nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
      subtitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
    ])
  }
  
}
