//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by 배지영 on 2021/11/11.
//
import Combine
import CombineExt
import Foundation


/// 값들이 최신을 유지하되, 직접 send할 수 없게 하는 매커니즘이 필요해서 만든 Utils
/// 잔액을 사용하는 객체들이 사용, 값을 직접 send할 수는 없되, value를 통해 현재 잔액을 받아갈 수 있도록 한다.
public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
  
  public typealias Output = Element
  public typealias Failure = Never
  
  public var value: Element {
    currentValueRelay.value
  }
  
  fileprivate let currentValueRelay: CurrentValueRelay<Output>
  
  fileprivate init(_ initialValue: Element) {
    currentValueRelay = CurrentValueRelay(initialValue)
  }
  
  public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
    currentValueRelay.receive(subscriber: subscriber)
  }
  
}

/// 잔액을 관리하는 객체가 CurrentValuePublisher을 생성을 해서 잔액이 바뀔 때마다 send()를 해줄 것
public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
  
  public typealias Output = Element
  public typealias Failure = Never
  
  public override init(_ initialValue: Element) {
    super.init(initialValue)
  }
  
  public func send(_ value: Element) {
    currentValueRelay.accept(value)
  }
  
}
