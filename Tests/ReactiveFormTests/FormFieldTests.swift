import XCTest
import ReactiveForm

private class ProfileForm: ObservableForm {
  @FormField(validators: [.required])
  var name = "Mario"
}

final class FormFieldTests: XCTestCase {
  func testWrappedValue() throws {
    let form = ProfileForm()

    XCTAssertEqual(form.name, "Mario")
  }

  func testProjectedValue() throws {
    let form = ProfileForm()

    XCTAssertEqual(form.$name.value, "Mario")
    XCTAssertEqual(form.$name.validators[0].id, Validator.required.id)
  }

  func testUpdatingValue() throws {
    let form = ProfileForm()

    form.name = "Luigi"

    XCTAssertEqual(form.$name.value, "Luigi")
  }
}
