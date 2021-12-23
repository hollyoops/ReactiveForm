import XCTest
import ObservableForm

class ProfileForm: ObservableForm {
  @FormField(validators: [Validator.required])
  var name: String = ""
  
  @FormField(validators: [Validator.required, Validator.email])
  var email: String = ""
}

class SettingForm: ObservableForm {
  var name = FormControl("", validators: [Validator.required])
  var email = FormControl("", validators: [Validator.required, Validator.email])
}

final class ObservableFormTests: XCTestCase {
  func testFormField() throws {
    let profileForm = ProfileForm()

    XCTAssertTrue(profileForm.$email.isValid)
    
    profileForm.$email.value = "test"
    
    XCTAssertFalse(profileForm.$email.isValid)

    profileForm.$email.value = "test@gmail.com"

    XCTAssertTrue(profileForm.$email.isValid)
  }

  func testFormControl() throws {
    let settingForm = SettingForm()

    XCTAssertTrue(settingForm.email.isValid)

    settingForm.email.value = "test"

    XCTAssertFalse(settingForm.email.isValid)

    settingForm.email.value = "test@gmail.com"

    XCTAssertTrue(settingForm.email.isValid)
  }
}
