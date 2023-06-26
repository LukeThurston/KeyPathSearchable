import Foundation

public protocol KeyPathSearchable: KeyPathListable, Hashable, Identifiable {
    
    typealias SearchResult = [String : Any]
    
    func search(_ searchTerm: String) -> SearchResult?
    
}

extension KeyPathSearchable {
    
    public func search(_ searchTerm: String) -> SearchResult? {
        var result = SearchResult()
        allKeyPaths.forEach { key, keyValuePath in
            let value = self.valueFor(keyValuePath)
            if let array = value as? [any KeyPathSearchable],
               let subArrayResults = search(for: searchTerm, in: array) {
                subArrayResults.forEach { subArrayKey, value in
                    result["\(key) \(subArrayKey)"] = value
                }
            } else if let dict = value as? [AnyHashable : any KeyPathSearchable],
                      let subArrayResults = search(for: searchTerm, in: Array(dict.values)) {
                subArrayResults.forEach { subArrayKey, value in
                    result["\(key) \(subArrayKey)"] = value
                }
            } else if let keyPathSearchableValue = value as? (any KeyPathSearchable),
                      let results = keyPathSearchableValue.search(searchTerm) {
                results.forEach { subKey, value in
                    result["\(key) \(subKey)"] = value
                    
                }
            }
        }
        return result.isEmpty ? nil : result
    }
    
    private func search(for searchTerm: String, in array: [any KeyPathSearchable]) -> SearchResult? {
        var result = SearchResult()
        
        array.forEach { element in
            guard let searchResult = element.search(searchTerm) else { return }
            searchResult.forEach { key, value in
                result["\(key)"] = value
            }
        }
        
        return result.isEmpty ? nil : result
    }
    
}
