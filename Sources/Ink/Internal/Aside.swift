//
//  File.swift
//  
//
//  Created by Todd Olsen on 4/17/20.
//

internal struct Aside: Fragment {
    var modifierTarget: Modifier.Target { .asides }

    private var text: FormattedText

    static func read(using reader: inout Reader) throws -> Aside {
        try reader.read("^")
        try reader.readWhitespaces()

        var text = FormattedText.readLine(using: &reader)

        while !reader.didReachEnd {
            switch reader.currentCharacter {
            case \.isNewline:
                return Aside(text: text)
            case "^":
                reader.advanceIndex()
            default:
                break
            }

            text.append(FormattedText.readLine(using: &reader))
        }

        return Aside(text: text)
    }

    func html(usingURLs urls: NamedURLCollection,
              modifiers: ModifierCollection) -> String {
        let body = text.html(usingURLs: urls, modifiers: modifiers)
        return "<aside><p>\(body)</p></aside>"
    }

    func plainText() -> String {
        text.plainText()
    }
}
