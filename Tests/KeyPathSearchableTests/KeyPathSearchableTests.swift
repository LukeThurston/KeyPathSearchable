import XCTest
@testable import KeyPathSearchable

final class KeyPathSearchableTests: XCTestCase {
    
    func testAlternateCodingKey() {
        let obj = MockObject(id: "luke", name: "Luke Thurston")
        let searchTerm: String = "Luke"
        
        let result = obj.search(searchTerm) as! [String : String]
        let expected: [String : String] = [
            "NOME" : "Luke Thurston"
        ]
        
        XCTAssertEqual(result, expected)
    }
    
    func testComputedCodingKey() {
        let obj = MockObject(id: "luke", name: "Luke Thurston")
        let searchTerm: String = "13"

        let result = obj.search(searchTerm) as! [String : String]
        let expected: [String : String] = [
            "age" : "13"
        ]

        XCTAssertEqual(result, expected)
    }
    
    func testComputedDict() {
        let subObj = MockObject(id: "katherine", name: "Katherine Thurston")
        let obj = MockObject(id: "luke", name: "Luke Thurston", dict: ["katherine" : subObj])
        let searchTerm: String = "Thurston"

        let result = obj.search(searchTerm) as! [String : String]
        let expected: [String : String] = [
            "NOME" : "Luke Thurston",
            "dict NOME" : "Katherine Thurston"
        ]

        XCTAssertEqual(result, expected)
    }
    
}

struct MockObject: Codable {
    
    let id: String
    let name: String
    let dict: [String : MockObject]
    
    var age: Int {
        name.count
    }
    
    init(id: String, name: String, dict: [String : MockObject] = [:]) {
        self.id = id
        self.name = name
        self.dict = dict
    }
    
    static func == (lhs: MockObject, rhs: MockObject) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension MockObject: KeyPathSearchable {
    
    init() {
        self.id = ""
        self.name = ""
        self.dict = [:]
    }
    
    public var keyPathReadableFormat: [String: Any] {
        return [
            "NOME" : name,
            "id" : id,
            "dict" : dict,
            "age" : age
        ]
    }
    
}
