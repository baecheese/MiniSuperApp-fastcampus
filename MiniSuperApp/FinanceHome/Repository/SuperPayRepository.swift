//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/12/01.
//

import Foundation
import Combine

protocol SuperPayRepository {
  var blance: ReadOnlyCurrentValuePublisher<Double> { get }
  
  func topup(amount: Double, paymentId: String) -> AnyPublisher<Void, Error>
}

class SuperPayRepositoryImp: SuperPayRepository {
  
  var blance: ReadOnlyCurrentValuePublisher<Double> { blanceSubject }
  // 원래였으면 서버에서 받아와야 하지만, 이 예제 프로젝트에서는 초기값을 준다.
  private let blanceSubject = CurrentValuePublisher<Double>(0.0)
  
  func topup(amount: Double, paymentId: String) -> AnyPublisher<Void, Error> {
    // 서버가 없어서 보이기에 call back 효과를 주기위한 코드
    return Future<Void, Error> { [weak self] promise in
      self?.bgQueue.async {
        Thread.sleep(forTimeInterval: 2.0)
        promise(.success(()))
      }
    }.eraseToAnyPublisher()
  }
  
  private let bgQueue: DispatchQueue = DispatchQueue(label: "topup.repository.queue")
}
