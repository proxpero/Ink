internal struct Section: Fragment {
    var modifierTarget: Modifier.Target { .sections }
    var level: Int

    private var text: FormattedText

    static func read(using reader: inout Reader) throws -> Section {
        let level = reader.readCount(of: "§")
        try require(level > 0 && level < 7)
        try reader.readWhitespaces()
        let text = FormattedText.read(using: &reader, terminators: ["\n"])

        return Section(level: level, text: text)
    }

    func html(
        usingURLs urls: NamedURLCollection,
        modifiers: ModifierCollection
    ) -> String {
        let body = stripTrailingMarkers(from: text.html(usingURLs: urls, modifiers: modifiers))
        let tagName = "h\(level)"
        let id = text.plainText().idValue
        return "<\(tagName)><a id='\(id)' href='#\(id)'>\(body)</a></\(tagName)>"
    }

    func plainText() -> String {
        stripTrailingMarkers(from: text.plainText())
    }
}

private extension Section {
    func stripTrailingMarkers(from text: String) -> String {
        guard !text.isEmpty else { return text }

        let lastCharacterIndex = text.index(before: text.endIndex)
        var trimIndex = lastCharacterIndex

        while text[trimIndex] == "§", trimIndex != text.startIndex {
            trimIndex = text.index(before: trimIndex)
        }

        if trimIndex != lastCharacterIndex {
            return String(text[..<trimIndex])
        }

        return text
    }
}

extension StringProtocol {
    var idValue: String {
        self.lowercased().replacingOccurrences(of: " ", with: "-")
    }
}

extension Character {
    var isSectionMark: Bool {
        self == "§"
    }

    var isSlash: Bool {
        self == "/"
    }
}
