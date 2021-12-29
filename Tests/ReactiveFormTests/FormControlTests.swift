import XCTest
import ReactiveForm

final class FormControlTests: XCTestCase {
  func testInitWithInvalidValue() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testInitWithValidValue() throws {
    let name = FormControl("Mario", validators: [.required])

    XCTAssertTrue(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])
  }

  func testUpdateWithInvalidValue() throws {
    let name = FormControl("Mario", validators: [.required])

    name.value = ""

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testUpdateWithValidValue() throws {
    let name = FormControl("", validators: [.required])

    name.value = "Mario"

    XCTAssertTrue(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])
  }

  func testUpdateWithInvalidPendingValue() throws {
    let name = FormControl("Mario", validators: [.required])

    name.pendingValue = ""

    XCTAssertTrue(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])
  }

  func testUpdateWithValidPendingValue() throws {
    let name = FormControl("", validators: [.required])

    name.pendingValue = "Mario"

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testUpdateValueAndValidityWithInvalidPendingValue() throws {
    let name = FormControl("Mario", validators: [.required])

    name.pendingValue = ""
    name.updateValueAndValidity()

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testUpdateValueAndValidityWithValidPendingValue() throws {
    let name = FormControl("", validators: [.required])

    name.pendingValue = "Mario"
    name.updateValueAndValidity()

    XCTAssertTrue(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])
  }

  func testValidationErrorWithUnrelatedValidator() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertFalse(name.errors[.email])
  }

  func testValidationErrorWithValidValue() throws {
    let name = FormControl("Mario", validators: [.required])

    XCTAssertFalse(name.errors[.required])
  }

  func testValidationErrorWithInvalidValue() throws {
    let name = FormControl("", validators: [.required])

    XCTAssertTrue(name.errors[.required])
  }

  func testPristineStateWithDefaultValue() throws {
    let name = FormControl("Mario")

    XCTAssertTrue(name.isPristine)
    XCTAssertFalse(name.isDirty)
  }

  func testPristineStateWithChangedValue() throws {
    let name = FormControl("Mario")

    name.value = "Luigi"

    XCTAssertFalse(name.isPristine)
    XCTAssertTrue(name.isDirty)
  }

  func testPristineStateWithChangedPendingValue() throws {
    let name = FormControl("Mario")

    name.pendingValue = "Luigi"

    XCTAssertTrue(name.isPristine)
    XCTAssertFalse(name.isDirty)
  }

  func testPristineStateWithAppliedValue() throws {
    let name = FormControl("Mario")

    name.pendingValue = "Luigi"
    name.updateValueAndValidity()

    XCTAssertFalse(name.isPristine)
    XCTAssertTrue(name.isDirty)
  }

  func testMarkAsDirty() throws {
    let name = FormControl("Mario")

    name.markAsDirty()

    XCTAssertFalse(name.isPristine)
    XCTAssertTrue(name.isDirty)
  }

  func testMarkAsPristine() throws {
    let name = FormControl("Mario")
    name.value = "Luigi"

    name.markAsPristine()

    XCTAssertTrue(name.isPristine)
    XCTAssertFalse(name.isDirty)
  }
}
