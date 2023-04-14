import SwiftUI

public struct SearchResultViewModifier: ViewModifier {
    
    private let searchTerm: String
    private let dict: [String : Any]
    
    /// Adds rows under a view with object key path and key path value highlighting the matched search term
    /// - Parameters:
    ///   - searchTerm: The search term used
    ///   - dict: A dictionary of the key path and the value of the key path that was found to contain or match the search term
    public init(searchTerm: String, dict: [String : Any]) {
        self.searchTerm = searchTerm
        self.dict = dict
    }
    
    public func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            content
            ForEach(dict.sorted(by: { $0.key > $1.key }), id:\.key) { dict in
                if let string = dict.value as? String {
                    LabeledContent {
                        HighlightableText(highlightString: searchTerm, baseString: string)
                    } label: {
                        Text(dict.key)
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                } else if let int = dict.value as? Int {
                    LabeledContent {
                        HighlightableText(highlightString: searchTerm, baseString: String("\(int)"))
                    } label: {
                        Text(dict.key)
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                } else if let dict = dict.value as? [String : Any] {
                    content.searchResult(with: dict, searchTerm: searchTerm)
                }
            }
        }
    }
}

extension View {
    
    /// Adds rows under a view with object key path and key path value highlighting the matched search term
    /// - Parameters:
    ///   - searchTerm: The search term used
    ///   - dict: A dictionary of the key path and the value of the key path that was found to contain or match the search term
    /// - Returns: View with view modifier applier
    public func searchResult(with dict: [String : Any], searchTerm: String) -> some View {
        modifier(SearchResultViewModifier(searchTerm: searchTerm, dict: dict))
    }
    
}


public struct SearchResultViewModifierExampleView: View {
    public var body: some View {
        Form {
            Text("Persons name")
                .searchResult(with: [:], searchTerm: "SearchTerm")
            
            Text("Persons name")
                .searchResult(with: ["First Name": "Luke"], searchTerm: "Luke")
            
            Text("Persons name")
                .searchResult(with: ["Name": "Luke Thurston"], searchTerm: "Luke")
        }
    }
}

struct SearchResultViewModifierExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultViewModifierExampleView()
    }
}
