import ModernRIBs
import Combine
import Foundation
import CombineUtil

public protocol TransportHomeRouting: ViewableRouting {
  func attatchTopup()
  func dettatchTopup()
}

protocol TransportHomePresentable: Presentable {
  var listener: TransportHomePresentableListener? { get set }
  
  func setSuperPayBalance(_ balance: String)
}

public protocol TransportHomeListener: AnyObject {
  func transportHomeDidTapClose()
}

protocol TransportHomeInteractorDependency {
  var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class TransportHomeInteractor: PresentableInteractor<TransportHomePresentable>, TransportHomeInteractable, TransportHomePresentableListener {
  
  weak var router: TransportHomeRouting?
  weak var listener: TransportHomeListener?
  
  // HEAD CODE: 임시 기본 택시 요금
  private let defaultTaxiPrice: Double = 18000.0
  
  private let dependency: TransportHomeInteractorDependency
  private var cancellable: Set<AnyCancellable>
  
  init(
    presenter: TransportHomePresentable,
    dependency: TransportHomeInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellable = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    dependency.superPayBalance
      .receive(on: DispatchQueue.main)
      .sink { [weak self] balance in
        if let balanceText = Formatter.balanceFormatter.string(from: NSNumber(value: balance)) {
          self?.presenter.setSuperPayBalance(balanceText)
        }
      }.store(in: &cancellable)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didTapBack() {
    listener?.transportHomeDidTapClose()
  }
  
  func didTapRideConfirmButton() {
    if dependency.superPayBalance.value < defaultTaxiPrice {
      router?.attatchTopup() 
    } else {
      print("SUCCESS")
    }
  }
  
  func topupDidClose() {
    router?.dettatchTopup()
  }
  
  func topupDidFinish() {
    router?.dettatchTopup()
  }
  
}
