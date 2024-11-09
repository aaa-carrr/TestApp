import XCTest
import SnapshotTesting
import SwiftUI
import TANetwork
@testable import TAPackage

@MainActor
final class TAMainViewTests: XCTestCase {
    let record = false
    
    func test_featureView_initialState() async {
        let networkMock = TANetworkMock(responseToBeReturned: nil, errorToBeReturned: nil)
        
        let sut = TAMainView(network: networkMock)
        
        let sutHostingViewController = UIHostingController(rootView: sut)
        sutHostingViewController.view.frame = UIScreen.main.bounds
        
        assertSnapshot(of: sutHostingViewController, as: .image, record: record)
    }
}

// MARK: - Test doubles
struct TANetworkMock: TANetworkType {
    let responseToBeReturned: (Sendable & Decodable)?
    let errorToBeReturned: TANetworkError?
    
    func perform<T: Decodable>(_ request: TANetworkRequest, for type: T.Type) async throws(TANetworkError) -> T {
        if let errorToBeReturned {
            throw (errorToBeReturned)
        }
        
        if let response = responseToBeReturned as? T {
            return response
        } else {
            throw(.requestFailed)
        }
    }
}
