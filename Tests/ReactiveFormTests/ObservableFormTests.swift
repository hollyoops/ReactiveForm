import XCTest
import ReactiveForm

private class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.required, .email])
}

final class ObservableFormTests: XCTestCase {
  func testFormControl() throws {
    let form = ProfileForm()

    XCTAssertFalse(form.email.isValid)
    XCTAssertTrue(form.email.errors[.email])

    form.email.value = "test"

    XCTAssertFalse(form.email.isValid)
    XCTAssertTrue(form.email.errors[.email])

    form.email.value = "test@gmail.com"

    XCTAssertTrue(form.email.isValid)
    XCTAssertFalse(form.email.errors[.email])
  }

  func testUpdateValueAndValidity() {
    let form = ProfileForm()

    form.name.pendingValue = "Mario"
    form.email.pendingValue = "test@gmail.com"

    XCTAssertFalse(form.isValid)
    XCTAssertTrue(form.isInvalid)

    form.updateValueAndValidity()

    XCTAssertTrue(form.isValid)
    XCTAssertFalse(form.isInvalid)
  }
}
