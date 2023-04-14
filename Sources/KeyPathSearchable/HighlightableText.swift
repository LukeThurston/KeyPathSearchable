import SwiftUI

public struct HighlightableText: View {
    
    private let highlightString: String
    private let baseString: String

    public init(highlightString: String = "", baseString: String = "") {
        self.highlightString = highlightString
        self.baseString = baseString
    }
    
    public var body: some View {
        highlightedText(str: baseString, searched: highlightString)
            .multilineTextAlignment(.leading)
    }

    private func highlightedText(str: String, searched: String) -> Text {
        guard !str.isEmpty && !searched.isEmpty else { return Text(str) }

        var result: Text!
        let parts = str.components(separatedBy: searched)
        for i in parts.indices {
            result = (result == nil ? Text(parts[i]) : result + Text(parts[i]))
            if i != parts.count - 1 {
                result = result + Text(searched).fontWeight(.heavy)
            }
        }
        return result ?? Text(str)
    }
}


struct HighlightableText_Previews: PreviewProvider {
    static var previews: some View {
        HighlightableText(highlightString: "Ex", baseString: "Example")
        
        HighlightableText(highlightString: "07",
                          baseString: "07507555890")
    }
}
