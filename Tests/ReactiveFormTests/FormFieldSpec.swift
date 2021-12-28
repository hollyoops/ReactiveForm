import Quick
import Nimble
import ReactiveForm

private class ProfileForm: ObservableForm {
  @FormField(validators: [.required])
  var name = "Mario"
}

class ForFieldSpec: QuickSpec {
  override func spec() {
    describe("FormField.wrappedValue") {
      it("should get correct value") {
        let form = ProfileForm()

        expect(form.name) == "Mario"
      }
    }

    describe("FormField.projectedValue") {
      context("init") {
        it("should get init value") {
          let form = ProfileForm()

          expect(form.$name.value) == "Mario"
        }
      }

      context("update wrappedValue") {
        it("should get updated value from projectValue") {
          let form = ProfileForm()

          form.name = "Luigi"

          expect(form.$name.value) == "Luigi"
        }
      }
    }
  }
}
