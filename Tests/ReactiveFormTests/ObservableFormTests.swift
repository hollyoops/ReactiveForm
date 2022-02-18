import XCTest
import ReactiveForm

private class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.required, .email])
}

private class PrefilledProfileForm: ObservableForm {
  var name = FormControl("Mario", validators: [.required])
  var email = FormControl("test@gmail.com", validators: [.required, .email])
}

private class ManuallyProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required], type: .manually)
  var email = FormControl("", validators: [.required, .email], type: .manually)
}

final class ObservableFormTests: XCTestCase {
  func testInitWithInvalidValues() throws {
    let form = ProfileForm()

    XCTAssertFalse(form.isValid)
    XCTAssertTrue(form.isInvalid)

    XCTAssertFalse(form.name.isValid)
    XCTAssertTrue(form.name.isInvalid)

    XCTAssertFalse(form.email.isValid)
    XCTAssertTrue(form.email.isInvalid)
  }

  func testInitWithValidValues() throws {
    let form = PrefilledProfileForm()

    XCTAssertTrue(form.isValid)
    XCTAssertFalse(form.isInvalid)

    XCTAssertTrue(form.name.isValid)
    XCTAssertFalse(form.name.isInvalid)

    XCTAssertTrue(form.email.isValid)
    XCTAssertFalse(form.email.isInvalid)
  }

  func testUpdateWithinvalidValues() throws {
    let form = PrefilledProfileForm()

    form.name.value = ""

    XCTAssertFalse(form.isValid)
    XCTAssertTrue(form.isInvalid)
  }

  func testUpdateWithValidValues() throws {
    let form = ProfileForm()

    form.name.value = "Mario"

    XCTAssertFalse(form.isValid)
    XCTAssertTrue(form.isInvalid)
    XCTAssertTrue(form.name.isValid)
    XCTAssertFalse(form.name.isInvalid)
    XCTAssertFalse(form.email.isValid)
    XCTAssertTrue(form.email.isInvalid)

    form.email.value = "test@gmail.com"

    XCTAssertTrue(form.isValid)
    XCTAssertFalse(form.isInvalid)
    XCTAssertTrue(form.name.isValid)
    XCTAssertFalse(form.name.isInvalid)
    XCTAssertTrue(form.email.isValid)
    XCTAssertFalse(form.email.isInvalid)
  }

  func testPristineStateWithDefaultValue() throws {
    let form = ProfileForm()

    XCTAssertTrue(form.isPristine)
    XCTAssertFalse(form.isDirty)
  }

  func testPristineStateWithChangedValue() throws {
    let form = ProfileForm()

    form.name.value = "Mario"

    XCTAssertFalse(form.isPristine)
    XCTAssertTrue(form.isDirty)
  }
  
  func testValidate() throws {
    let form = ManuallyProfileForm()

    XCTAssertTrue(form.isValid)
    
    form.name.value = "Mario"
    
    XCTAssertTrue(form.isValid)
    
    form.validate()
    
    XCTAssertFalse(form.isValid)
  }
}
