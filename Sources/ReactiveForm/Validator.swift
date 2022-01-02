import Foundation

/// A validator that performs synchronous validation.
public struct Validator<Value>: Identifiable {
  public typealias ValidatorFn = (Value) -> Bool

  /// Identifier of a validator of the same type.
  public private(set) var id: UUID
  /// Validator function.
  public private(set) var fn: ValidatorFn

  // TODO: check duplicated id
  /// Creates a validator with the provided identifier.
  public init(id: UUID, fn: @escaping ValidatorFn) {
    self.id = id
    self.fn = fn
  }

  /// Creates a validator with a unique identifier.
  public init(_ fn: @escaping ValidatorFn) {
    self.id = UUID()
    self.fn = fn
  }
}

private enum Identifier {
  static let min = UUID()
  static let max = UUID()

  static let minLength = UUID()
  static let maxLength = UUID()
}

extension Validator where Value == String {
  /// Validator that requires the control have a non-empty value.
  public static let required = Validator(Rule.required)

  /// Validator that requires the control's value pass an email validation test.
  ///
  /// Tests the value using a [regular
  /// expression](https://developer.apple.com/documentation/foundation/nsregularexpression)
  /// pattern suitable for common usecases. The pattern is based on the definition of a valid email
  /// address in the [WHATWG HTML
  /// specification](https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address) with
  /// some enhancements to incorporate more RFC rules (such as rules related to domain names and the
  /// lengths of different parts of the address).
  ///
  /// The differences from the WHATWG version include:
  /// - Disallow `local-part` (the part before the `@` symbol) to begin or end with a period (`.`).
  /// - Disallow `local-part` to be longer than 64 characters.
  /// - Disallow the whole address to be longer than 254 characters.
  ///
  /// If this pattern does not satisfy your business needs, you can use `Validator<String>.pattern()` to
  /// validate the value against a different pattern.
  public static let email = Validator(Rule.email)

  /// Validator that requires the length of the control's value to be greater than
  /// or equal to the provided minimum length.
  public static func minLength(_ minimum: Int) -> Validator {
    Validator(id: Identifier.minLength) { value in
      Rule.minLength(value, minimumLength: minimum)
    }
  }

  /// Validator that requires the length of the control's value to be less than
  /// or equal to the provided maximum length.
  public static func maxLength(_ maximum: Int) -> Validator {
    Validator(id: Identifier.maxLength) { value in
      Rule.maxLength(value, maximumLength: maximum)
    }
  }
}

extension Validator where Value == Int {
  /// Validator that requires the control's value to be greater than
  /// or equal to the provided number.
  public static func min(_ minimum: Int) -> Validator {
    Validator(id: Identifier.min) { value in
      Rule.min(value, minimumValue: minimum)
    }
  }

  /// Validator that requires the control's value to be less than
  /// or equal to the provided number.
  public static func max(_ maximum: Int) -> Validator {
    Validator(id: Identifier.max) { value in
      Rule.max(value, maximumValue: maximum)
    }
  }
}

extension Validator where Value == Bool? {
  /// Validator that requires the control's value be true.
  public static let requiredTrue = Validator(Rule.requiredTrue)
}

private struct Rule {
  /// A regular expression that matches valid e-mail addresses.
  /// The implementation is directly from Angular.
  /// See [this commit](https://github.com/angular/angular.js/commit/f3f5cf72e)
  /// for more details.
  static let emailPattern = ##"^(?=.{1,254}$)(?=.{1,64}@)[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"##

  static func min(_ value: Int, minimumValue: Int) -> Bool {
    value >= minimumValue
  }

  static func max(_ value: Int, maximumValue: Int) -> Bool {
    value <= maximumValue
  }

  static func required(_ string: String) -> Bool {
    !string.isEmpty
  }

  static func email(_ string: String) -> Bool {
    NSPredicate(format:"SELF MATCHES %@", emailPattern)
      .evaluate(with: string)
  }

  static func minLength(_ string: String, minimumLength: Int) -> Bool {
    string.count >= minimumLength
  }

  static func maxLength(_ string: String, maximumLength: Int) -> Bool {
    string.count <= maximumLength
  }

  static func requiredTrue(_ value: Bool?) -> Bool {
    value ?? false
  }
}
