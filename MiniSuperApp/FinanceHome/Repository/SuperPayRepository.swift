//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/12/01.
//

import Foundation

protocol SuperPayRepostitory {
  var blance: ReadOnlyCurrentValuePublisher<Double> { get }
}

class SuperPayRepositoryImp: SuperPayRepostitory {
  
  var blance: ReadOnlyCurrentValuePublisher<Double> { blanceSubject }
  // 원래였으면 서버에서 받아와야 하지만, 이 예제 프로젝트에서는 초기값을 준다.
  private let blanceSubject = CurrentValuePublisher<Double>(0.0)
}
