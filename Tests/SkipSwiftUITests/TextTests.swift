// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import Foundation
#if !SKIP
@testable import SkipSwiftUI
#endif

final class TextTests: XCTestCase {
    #if !SKIP
    func testAttributedContentRetainsValueSemantics() throws {
        let original = AttributedString("Hello 👩🏽‍💻")
        var edited = original
        let range = try XCTUnwrap(edited.range(of: "👩🏽‍💻"))
        edited[range].foregroundColor = SkipSwiftUI.Color.blue
        edited[range].underlineStyle = SkipSwiftUI.Text.LineStyle.single
        edited[range].link = URL(string: "https://example.com")
        XCTAssertEqual(Text(original), Text(AttributedString("Hello 👩🏽‍💻")))
        XCTAssertNotEqual(Text(original), Text(edited))
        XCTAssertEqual(Text(edited).spec.attributedContent, edited)
        XCTAssertNil(original.runs.first?.link)
    }

    func testBaselineOffsetRetainsValueSemantics() throws {
        let original = AttributedString("x2 H2O")
        var edited = original
        let exponent = try XCTUnwrap(edited.range(of: "x2"))
        edited[exponent].skipUI.baselineOffset = 6
        let subscriptRange = try XCTUnwrap(edited.range(of: "H2O"))
        edited[subscriptRange].skipUI.baselineOffset = -4
        XCTAssertEqual(edited[exponent].skipUI.baselineOffset, 6)
        XCTAssertEqual(edited[subscriptRange].skipUI.baselineOffset, -4)
        XCTAssertNil(original.skipUI.baselineOffset)
        XCTAssertNotEqual(Text(original), Text(edited))
        edited[exponent].skipUI.baselineOffset = 0
        XCTAssertEqual(edited[exponent].skipUI.baselineOffset, 0)
    }

    /// SwiftUI documents `Text.init<S>(_:)` as displaying "a stored string without
    /// localization", so an already-resolved string must not be looked up again (#135).
    func testStringProtocolInitIsVerbatim() throws {
        let resolved = "Welcome"
        let text = Text(resolved)
        XCTAssertEqual(text.spec.verbatim, "Welcome")
        XCTAssertNil(text.spec.key)
        XCTAssertEqual(text, Text(verbatim: resolved))
    }

    /// A `Substring` binds to the same overload and must not be localized either.
    func testSubstringInitIsVerbatim() throws {
        let resolved = "Welcome!".dropLast()
        XCTAssertEqual(Text(resolved).spec.verbatim, "Welcome")
    }

    /// A string literal still binds to the `LocalizedStringKey` overload and stays localized.
    func testStringLiteralInitRemainsLocalized() throws {
        let text = Text("Welcome")
        XCTAssertEqual(text.spec.key, LocalizedStringKey("Welcome"))
        XCTAssertNil(text.spec.verbatim)
    }
    #endif
}
