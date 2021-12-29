import XCTest
import ReactiveForm

final class ValidatorTests: XCTestCase {
  func testRequiredOfString() throws {
    performTest(
      for: .required,
      cases: [
        ("", false),
        (" ", true),
        ("Mario", true),
      ]
    )
  }

  func testEmail() throws {
    performTest(
      for: .email,
      cases: [
        ("mario", false),
        ("mario@", false),
        ("test@gmail.com", true),
      ]
    )
  }

  func testIdentifierOfMinLengthOfString() throws {
    XCTAssertEqual(
      Validator.minLength(5).id,
      Validator.minLength(10).id
    )
  }

  func testMinLengthOfString() throws {
    performTest(
      for: .minLength(5),
      cases: [
        ("1234", false),
        ("12345", true),
      ]
    )
  }

  func testIdentifierOfMaxLengthOfString() throws {
    XCTAssertEqual(
      Validator.maxLength(5).id,
      Validator.maxLength(10).id
    )
  }

  func testMaxLengthOfString() throws {
    performTest(
      for: .maxLength(5),
      cases: [
        ("123456", false),
        ("12345", true),
      ]
    )
  }

  func testIdentifierOfMinOfInt() throws {
    XCTAssertEqual(
      Validator.min(5).id,
      Validator.min(10).id
    )
  }

  func testMinOfInt() throws {
    performTest(
      for: .min(5),
      cases: [
        (4, false),
        (5, true),
      ]
    )
  }

  func testIdentifierOfMaxOfInt() throws {
    XCTAssertEqual(
      Validator.max(5).id,
      Validator.max(10).id
    )
  }

  func testMaxOfInt() throws {
    performTest(
      for: .max(5),
      cases: [
        (6, false),
        (5, true),
      ]
    )
  }

  func testRequiredTrue() throws {
    performTest(
      for: .requiredTrue,
      cases: [
        (false, false),
        (nil, false),
        (true, true),
      ]
    )
  }
}

extension ValidatorTests {
  func performTest<Value>(
    for validator: Validator<Value>,
    cases: [(givenValue: Value, expectedValidity: Bool)]
  ) {
    cases.forEach { (givenValue, expectedValidity) in
      XCTAssertEqual(
        validator.fn(givenValue),
        expectedValidity
      )
    }
  }
}
