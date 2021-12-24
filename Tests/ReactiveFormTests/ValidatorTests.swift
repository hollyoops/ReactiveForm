import XCTest
import ReactiveForm

class ValidatorTests: XCTestCase {
  func testStringRequired() throws {
    XCTAssertFalse(Validator.required.fn(""))
    XCTAssertTrue(Validator.required.fn(" "))
    XCTAssertTrue(Validator.required.fn("Mario"))
  }

  func testStringEmail() throws {
    XCTAssertFalse(Validator.email.fn("mario"))
    XCTAssertFalse(Validator.email.fn("mario@"))
    // XCTAssertTrue(Validator.email.fn("mario@local"))
    XCTAssertTrue(Validator.email.fn("mario@gmail.com"))
  }

  func testStringMinLength() throws {
    XCTAssertEqual(Validator.minLength(5).id, Validator.minLength(10).id)

    XCTAssertFalse(Validator.minLength(5).fn("1234"))
    XCTAssertTrue(Validator.minLength(5).fn("12345"))
  }

  func testStringMaxLength() throws {
    XCTAssertEqual(Validator.maxLength(5).id, Validator.maxLength(10).id)

    XCTAssertFalse(Validator.maxLength(5).fn("123456"))
    XCTAssertTrue(Validator.maxLength(5).fn("12345"))
  }

  func testIntMin() throws {
    XCTAssertEqual(Validator.min(3).id, Validator.min(5).id)

    XCTAssertFalse(Validator.min(5).fn(4))
    XCTAssertTrue(Validator.min(5).fn(5))
  }

  func testIntMax() throws {
    XCTAssertEqual(Validator.max(3).id, Validator.max(5).id)

    XCTAssertFalse(Validator.max(5).fn(6))
    XCTAssertTrue(Validator.max(5).fn(5))
  }

  func testOptionalBoolRequiredTrue() throws {
    XCTAssertFalse(Validator.requiredTrue.fn(false))
    XCTAssertFalse(Validator.requiredTrue.fn(nil))
    XCTAssertTrue(Validator.requiredTrue.fn(true))
  }
}
