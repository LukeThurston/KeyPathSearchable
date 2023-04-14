import Foundation

protocol KeyPathListable {
    
    associatedtype AnyOldObject

    init()

    var keyPathReadableFormat: [String: Any] { get }
    var allKeyPaths: [String:KeyPath<AnyOldObject, Any?>] { get }
    
    func valueFor(_ keyPath: KeyPath<AnyOldObject, Any?>) -> Any?
    
}

extension KeyPathListable {

    var keyPathReadableFormat: [String: Any] {
        var description: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            description[label] = value
        }
        return description
    }

    var allKeyPaths: [String:KeyPath<Self, Any?>] {
        var membersTokeyPaths: [String:KeyPath<Self, Any?>] = [:]
        let instance = Self()
        for (key, _) in instance.keyPathReadableFormat {
            membersTokeyPaths[key] = \Self.keyPathReadableFormat[key]
        }
        return membersTokeyPaths
    }
    
    func valueFor(_ keyPath: KeyPath<AnyOldObject, Any?>) -> Any? {
        return (self as! AnyOldObject)[keyPath: keyPath]
    }

}
