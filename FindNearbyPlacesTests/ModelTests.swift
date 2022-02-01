//
//  ModelTests.swift
//  FindNearbyPlacesTests
//
//  Created by Daniel González Méndez on 25/1/22.
//

import XCTest
@testable import FindNearbyPlaces

class ModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchPlaceResponse() throws {
        let response = try Place.jsonDecoder.decode(SearchPlaceResponse.self, from: searchPlaceData)
        XCTAssert(response.results.count == 10)
        XCTAssert(response.context?.geoBounds?.circle?.center?.latitude == 28.47697)
        XCTAssert(response.context?.geoBounds?.circle?.center?.longitude == -16.30854)
        XCTAssert(response.context?.geoBounds?.circle?.radius == 2631)
    }
    
    func testAutocompleteResponse() throws {
        let response = try Place.jsonDecoder.decode(AutocompleteResponse.self, from: autocompleData)
        XCTAssert(response.results.count == 10)
        for i in 0...1 {
            XCTAssert(response.results[i].type == .place)
            XCTAssert(response.results[i].place != nil)
            XCTAssert(response.results[i].search == nil)
        }
        for i in 2..<10 {
            XCTAssert(response.results[i].type == .search)
            XCTAssert(response.results[i].search != nil)
            XCTAssert(response.results[i].place == nil)
        }
    }
    
    func testPlaceCore() throws {
        let place = try Place.jsonDecoder.decode(Place.self, from: singlePlaceCore)
        XCTAssert(place.fsqId == place.id)
        XCTAssert(place.fsqId == "4d2246588629224bedf92187")
        XCTAssert(place.name == "Maxipizza")
        XCTAssert(place.distance == 2362)
        XCTAssert(place.photos?.count == 5)
        XCTAssert(place.location?.locality == "La Laguna")
    }

}

extension ModelTests {
    
    var searchPlaceData: Data {
        LocalFileManager.load(jsonFileName: "SearchPlaceResponse")
    }
    
    var autocompleData: Data {
        LocalFileManager.load(jsonFileName: "AutocompleteResponse")
    }
    
    var singlePlaceCore: Data {
        LocalFileManager.load(jsonFileName: "SinglePlaceCore")
    }
    
//    private func load(jsonFileName: String) -> Data {
//        do {
//            guard let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
//                fatalError("Invalid URL")
//            }
//            let string = try String(contentsOfFile: path)
//            guard let data = string.data(using: .utf8) else { fatalError("Cannot convert to data") }
//            return data
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
}
