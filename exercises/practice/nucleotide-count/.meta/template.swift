import XCTest
@testable import {{exercise|camelCase}}
class {{exercise|camelCase}}Tests: XCTestCase {
    let runAll = Bool(ProcessInfo.processInfo.environment["RUNALL", default: "false"]) ?? false

    {% for case in cases %}
    {% if forloop.first -%}
        func test{{case.description |camelCase }}() {
    {% else -%}
        func test{{case.description |camelCase }}() throws {
        try XCTSkipIf(true && !runAll) // change true to false to run this test
    {% endif -%}
    {% if case.expected.error -%}
        XCTAssertThrowsError(try DNA(strand: "{{case.input.strand}}")) { error in
            XCTAssertEqual(error as? NucleotideCountErrors, NucleotideCountErrors.invalidNucleotide)
        }
    {% else -%}
        let dna = try! DNA(strand: "{{case.input.strand}}")
        let results = dna.counts()
        let expected = {{case.expected | toStringDictionary}}
        XCTAssertEqual(results, expected)
    {% endif -%}
    }
    {% endfor -%}
}
