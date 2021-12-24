import XCTest
import ReactiveForm

fileprivate class ProfileForm: ObservableForm {
  @FormField(validators: [.required], strategy: .never)
  var name = "Mario"
}

final class FormFieldTests: XCTestCase {
  func testWrappedValue() throws {
    let profileForm = ProfileForm()

    XCTAssertEqual(profileForm.name, "Mario")
  }

  func testProjectedValue() throws {
    let profileForm = ProfileForm()

    XCTAssertEqual(profileForm.$name.value, "Mario")
    XCTAssertEqual(profileForm.$name.validators, [.required])
    XCTAssertEqual(profileForm.$name.strategy, .never)
  }

  func testUpdatingValue() throws {
    let profileForm = ProfileForm()

    profileForm.name = "Luigi"

    XCTAssertEqual(profileForm.$name.value, "Luigi")
  }
}
