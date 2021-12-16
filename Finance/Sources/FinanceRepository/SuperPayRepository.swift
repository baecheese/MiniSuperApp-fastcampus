//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/12/01.
//

import Foundation
import Combine
import CombineUtil
import Network

public protocol SuperPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  
  func topup(amount: Double, paymentId: String) -> AnyPublisher<Void, Error>
}

public class SuperPayRepositoryImp: SuperPayRepository {
  
  public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
  // 원래였으면 서버에서 받아와야 하지만, 이 예제 프로젝트에서는 초기값을 준다.
  private let balanceSubject = CurrentValuePublisher<Double>(0.0)
  
  public func topup(amount: Double, paymentId: String) -> AnyPublisher<Void, Error> {
    let request = TopupRequest(baseURL: baseURL, amount: amount, paymentMethod: paymentId)
    return network.send(request)
      .handleEvents( // 서버가 없기 때문에 수동으로 넣어줌
        receiveSubscription: nil,
        receiveOutput: { [weak self] _ in
          let newBalance = (self?.balanceSubject.value).map { $0 + amount }
          newBalance.map { self?.balanceSubject.send($0) }          
        },
        receiveCompletion: nil,
        receiveCancel: nil,
        receiveRequest: nil
      )
      .map { _ in }
      .eraseToAnyPublisher()
  }
  
  private let bgQueue: DispatchQueue = DispatchQueue(label: "topup.repository.queue")
  
  private let network: Network
  private let baseURL: URL
  
  public init(network: Network, baseURL: URL) {
    self.network = network
    self.baseURL = baseURL
  }
}
