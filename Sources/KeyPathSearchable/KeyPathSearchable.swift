import Foundation

public protocol KeyPathSearchable: KeyPathListable, Hashable, Identifiable {
    
    typealias SearchResult = [String : Any]
    
    func search(_ searchTerm: String) -> SearchResult?
    
}

extension KeyPathSearchable {
    
    public func search(_ searchTerm: String) -> SearchResult? {
        var result = SearchResult()
        allKeyPaths.forEach { key, keyValuePath in
            var optionalStringOfKeyPath: String? = nil
            
            let value = self.valueFor(keyValuePath)
            
            if let array = value as? [any KeyPathSearchable] {
                array.forEach { p in
                    guard let searchResult = p.search(searchTerm) else { return }
                    result["\(key).\(p.id)"] = searchResult
                }
            }
            
            if let string = value as? String {
                optionalStringOfKeyPath = string
            } else if let int = value as? Int {
                optionalStringOfKeyPath = String(int)
            }
            
            if let keyPathValue = optionalStringOfKeyPath, keyPathValue.contains(searchTerm) {
                result[key] = keyPathValue
            }
        }
        return result.isEmpty ? nil : result
    }
    
}
