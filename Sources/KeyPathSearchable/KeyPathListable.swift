import Foundation

public protocol KeyPathListable {
    
    associatedtype AnyOldObject

    init()

    var keyPathReadableFormat: [String: Any] { get }
    var allKeyPaths: [String:KeyPath<AnyOldObject, Any?>] { get }
    
    func valueFor(_ keyPath: KeyPath<AnyOldObject, Any?>) -> Any?
    
}

extension KeyPathListable {

    public var keyPathReadableFormat: [String: Any] {
        var description: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            description[label] = value
        }
        return description
    }

    public var allKeyPaths: [String:KeyPath<Self, Any?>] {
        var membersToKeyPaths: [String:KeyPath<Self, Any?>] = [:]
        let instance = Self()
        for (key, _) in instance.keyPathReadableFormat {
            membersToKeyPaths[key] = \Self.keyPathReadableFormat[key]
        }
        return membersToKeyPaths
    }
    
    public func valueFor(_ keyPath: KeyPath<AnyOldObject, Any?>) -> Any? {
        return (self as! AnyOldObject)[keyPath: keyPath]
    }

}
