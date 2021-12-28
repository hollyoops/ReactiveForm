import Quick
import Nimble
import ReactiveForm

class ValidatorSpec: QuickSpec {
  override func spec() {
    describe("Validator<String>.required") {
      it("should return correct validity") {
        self.performTest(
          for: .required,
          cases: [
            ("", false),
            (" ", true),
            ("Mario", true),
          ]
        )
      }
    }

    describe("Validator<String>.email") {
      it("should return correct validity") {
        self.performTest(
          for: .email,
          // TODO: Add more test cases here.
          cases: [
            ("mario", false),
            ("mario@", false),
            ("mario@gmail.com", true),
          ]
        )
      }
    }

    describe("Validator<String>.minLength") {
      it("should be the same id of the same type of validators") {
        expect(Validator.minLength(5).id) == Validator.minLength(10).id
      }

      it("should return correct validity") {
        self.performTest(
          for: .minLength(5),
          cases: [
            ("1234", false),
            ("12345", true),
          ]
        )
      }
    }

    describe("Validator<String>.maxLength") {
      it("should be the same id of the same type of validators") {
        expect(Validator.maxLength(5).id) == Validator.maxLength(10).id
      }

      it("should return correct validity") {
        self.performTest(
          for: .maxLength(5),
          cases: [
            ("123456", false),
            ("12345", true),
          ]
        )
      }
    }

    describe("Validator<Int>.min") {
      it("should be the same id of the same type of validators") {
        expect(Validator.min(5).id) == Validator.min(10).id
      }

      it("should return correct validity") {
        self.performTest(
          for: .min(5),
          cases: [
            (4, false),
            (5, true),
          ]
        )
      }
    }

    describe("Validator<Int>.max") {
      it("should be the same id of the same type of validators") {
        expect(Validator.max(5).id) == Validator.max(10).id
      }

      it("should return correct validity") {
        self.performTest(
          for: .max(5),
          cases: [
            (6, false),
            (5, true),
          ]
        )
      }
    }

    describe("Validator<Bool?>.requiredTrue") {
      it("should return correct validity") {
        self.performTest(
          for: .requiredTrue,
          cases: [
            (false, false),
            (nil, false),
            (true, true),
          ]
        )
      }
    }
  }

  private func performTest<Value>(
    for validator: Validator<Value>,
    cases: [(givenValue: Value, expectedValidity: Bool)]
  ) {
    cases.forEach { (givenValue, expectedValidity) in
      expect(validator.fn(givenValue)) == expectedValidity
    }
  }
}
