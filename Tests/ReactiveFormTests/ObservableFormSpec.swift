import Quick
import Nimble
import ReactiveForm

private class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.required, .email])
}

private class PrefilledProfileForm: ObservableForm {
  var name = FormControl("Mario", validators: [.required])
  var email = FormControl("test@gmail.com", validators: [.required, .email])
}

final class ObservableFormSpec: QuickSpec {
  override func spec() {
    describe("ObservableForm.init()") {
      context("init with invalid values") {
        it("should be invalid") {
          let form = ProfileForm()

          expect(form.isValid) == false
          expect(form.isInvalid) == true

          expect(form.name.isValid) == false
          expect(form.name.isInvalid) == true

          expect(form.email.isValid) == false
          expect(form.email.isInvalid) == true
        }
      }

      context("init with valid values") {
        it("should be valid") {
          let form = PrefilledProfileForm()

          expect(form.isValid) == true
          expect(form.isInvalid) == false

          expect(form.name.isValid) == true
          expect(form.name.isInvalid) == false

          expect(form.email.isValid) == true
          expect(form.email.isInvalid) == false
        }
      }
    }

    describe("Update form control's value") {
      context("updated control is invalid") {
        it("should be invalid") {
          let form = PrefilledProfileForm()

          form.name.value = ""

          expect(form.isValid) == false
          expect(form.isInvalid) == true
        }
      }

      context("updated control is valid") {
        it("should be valid") {
          let form = ProfileForm()

          form.name.value = "Mario"

          expect(form.isValid) == false
          expect(form.isInvalid) == true
          expect(form.name.isValid) == true
          expect(form.name.isInvalid) == false
          expect(form.email.isValid) == false
          expect(form.email.isInvalid) == true

          form.email.value = "test@gmail.com"

          expect(form.isValid) == true
          expect(form.isInvalid) == false
          expect(form.name.isValid) == true
          expect(form.name.isInvalid) == false
          expect(form.email.isValid) == true
          expect(form.email.isInvalid) == false
        }
      }
    }

    describe("ObservableForm.updateValueAndValidity()") {
      context("some of fields are invalid") {
        it("should be invalid") {
          let form = ProfileForm()
          form.name.pendingValue = "Mario"

          form.updateValueAndValidity()

          expect(form.isValid) == false
          expect(form.isInvalid) == true
          expect(form.name.isValid) == true
          expect(form.name.isInvalid) == false
          expect(form.email.isValid) == false
          expect(form.email.isInvalid) == true
        }
      }

      context("all fields are valid") {
        it("should be valid") {
          let form = ProfileForm()
          form.name.pendingValue = "Mario"
          form.email.pendingValue = "test@gmail.com"

          form.updateValueAndValidity()

          expect(form.isValid) == true
          expect(form.isInvalid) == false
          expect(form.name.isValid) == true
          expect(form.name.isInvalid) == false
          expect(form.email.isValid) == true
          expect(form.email.isInvalid) == false
        }
      }
    }
  }
}
