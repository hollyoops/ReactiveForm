import XCTest
import ReactiveForm

final class FormControlTests: XCTestCase {
  func testInitAndUpdateValueDirectly() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])

    name.value = "Mario"

    XCTAssertTrue(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])

    name.value = ""

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testInitAndUpdatePendingValue() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])

    name.pendingValue = "Mario"

    XCTAssertEqual(name.value, "")
    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testUpdateValidity() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])

    name.pendingValue = "Mario"
    name.updateValueAndValidity()

    XCTAssertTrue(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])
  }

  func testValidationErrors() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertTrue(name.errors[.required])
    // For unrelated error
    XCTAssertFalse(name.errors[.email])
  }
}
