import XCTest
import ReactiveForm

final class FormControlTests: XCTestCase {
  func testInitWithUpdateStrategyOnlyChange() throws {
    let name = FormControl(
      "",
      validators: [.required],
      strategy: .onlyChange
    )

    XCTAssertFalse(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])

    name.value = "Mario"
    name.value = ""

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }

  func testInitWithUpdateStrategyAlways() throws {
    let name = FormControl(
      "",
      validators: [.required],
      strategy: .always
    )

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

  func testInitWithUpdateStrategyNever() throws {
    let name = FormControl(
      "",
      validators: [.required],
      strategy: .never
    )

    XCTAssertFalse(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])

    name.value = "Mario"

    XCTAssertFalse(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])
  }

  func testUpdateValidity() throws {
    let name = FormControl(
      "",
      validators: [.required],
      strategy: .never
    )

    XCTAssertFalse(name.isValid)
    XCTAssertFalse(name.isInvalid)
    XCTAssertFalse(name.errors[.required])

    name.updateValidity()

    XCTAssertFalse(name.isValid)
    XCTAssertTrue(name.isInvalid)
    XCTAssertTrue(name.errors[.required])
  }
}
