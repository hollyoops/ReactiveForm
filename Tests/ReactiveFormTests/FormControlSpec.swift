import Quick
import Nimble
import ReactiveForm

class FormControlSpec: QuickSpec {
  override func spec() {
    describe("FormControl.init(_:validators:)") {
      context("init with invalid value") {
        it("should be invalid") {
          let name = FormControl("", validators: [.required])

          expect(name.isValid) == false
          expect(name.isInvalid) == true
          expect(name.errors[.required]) == true
        }
      }

      context("init with valid value") {
        it("should be valid") {
          let name = FormControl("Mario", validators: [.required])

          expect(name.isValid) == true
          expect(name.isInvalid) == false
          expect(name.errors[.required]) == false
        }
      }
    }

    describe("FormControl.value") {
      context("update with invalid value") {
        it("should be invalid") {
          let name = FormControl("Mario", validators: [.required])

          name.value = ""

          expect(name.isValid) == false
          expect(name.isInvalid) == true
          expect(name.errors[.required]) == true
        }
        
      }

      context("update with valid value") {
        it("should be valid") {
          let name = FormControl("", validators: [.required])

          name.value = "Mario"

          expect(name.isValid) == true
          expect(name.isInvalid) == false
          expect(name.errors[.required]) == false
        }
      }
    }

    describe("FormControl.pendingValue") {
      context("update with invalid pendingValue") {
        it("should not change validity") {
          let name = FormControl("Mario", validators: [.required])

          name.pendingValue = ""

          expect(name.isValid) == true
          expect(name.isInvalid) == false
          expect(name.errors[.required]) == false
        }

      }

      context("update with valid pendingValue") {
        it("should not change validity") {
          let name = FormControl("", validators: [.required])

          name.pendingValue = "Mario"

          expect(name.isValid) == false
          expect(name.isInvalid) == true
          expect(name.errors[.required]) == true
        }
      }
    }

    describe("FormControl.updateValueAndValidity") {
      context("pendingValue is invalid") {
        it("should be invalid") {
          let name = FormControl("Mario", validators: [.required])
          name.pendingValue = ""

          name.updateValueAndValidity()

          expect(name.isValid) == false
          expect(name.isInvalid) == true
          expect(name.errors[.required]) == true
        }
      }

      context("pendingValue is valid") {
        it("should be valid") {
          let name = FormControl("", validators: [.required])
          name.pendingValue = "Mario"

          name.updateValueAndValidity()

          expect(name.isValid) == true
          expect(name.isInvalid) == false
          expect(name.errors[.required]) == false
        }
      }
    }

    describe("FormControl.errors") {
      context("get error from the unrelated validator") {
        it("should be false") {
          let name = FormControl("", validators: [.required])

          expect(name.errors[.email]) == false
        }
      }

      context("has not corresponding error") {
        it("should be false") {
          let name = FormControl("Mario", validators: [.required])

          expect(name.errors[.required]) == false
        }
      }

      context("has corresponding error") {
        it("should be true") {
          let name = FormControl("", validators: [.required])

          expect(name.errors[.required]) == true
        }
      }
    }

    describe("FormControl.isPristine") {
      context("init default value") {
        it("should be pristine") {
          let name = FormControl("Mario")

          expect(name.isPristine) == true
          expect(name.isDirty) == false
        }
      }

      context("update value") {
        it("should be dirty") {
          let name = FormControl("Mario")

          name.value = "Luigi"

          expect(name.isPristine) == false
          expect(name.isDirty) == true
        }
      }

      context("update pendingValue") {
        it("should be pristine") {
          let name = FormControl("Mario")

          name.pendingValue = "Luigi"

          expect(name.isPristine) == true
          expect(name.isDirty) == false
        }
      }

      context("update pendingValue and updateValueAndValidity") {
        it("should be dirty") {
          let name = FormControl("Mario")

          name.pendingValue = "Luigi"
          name.updateValueAndValidity()

          expect(name.isPristine) == false
          expect(name.isDirty) == true
        }
      }
    }

    describe("FormControl.markAsPristine()") {
      context("mark as dirty") {
        it("should be dirty") {
          let name = FormControl("Mario")

          name.markAsDirty()

          expect(name.isPristine) == false
          expect(name.isDirty) == true
        }
      }

      context("mark as pristine") {
        it("should be pristine") {
          let name = FormControl("Mario")
          name.markAsDirty()

          name.markAsPristine()

          expect(name.isPristine) == true
          expect(name.isDirty) == false
        }
      }
    }
  }
}
