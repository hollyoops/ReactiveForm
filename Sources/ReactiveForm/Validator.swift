import Foundation

public struct Validator<Value>: Identifiable {
  public typealias ValidatorFn = (Value) -> Bool

  /// Identifier of a validator of the same type
  public private(set) var id: UUID
  public private(set) var fn: ValidatorFn

  // TODO: check duplicated id
  public init(id: UUID, fn: @escaping ValidatorFn) {
    self.id = id
    self.fn = fn
  }

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
  public static let required = Validator(Rule.required)
  public static let email = Validator(Rule.email)

  public static func minLength(_ minimum: Int) -> Validator {
    Validator(id: Identifier.minLength) { value in
      Rule.minLength(value, minimumLength: minimum)
    }
  }

  public static func maxLength(_ maximum: Int) -> Validator {
    Validator(id: Identifier.maxLength) { value in
      Rule.maxLength(value, maximumLength: maximum)
    }
  }
}

extension Validator where Value == Int {
  public static func min(_ minimum: Int) -> Validator {
    Validator(id: Identifier.min) { value in
      Rule.min(value, minimumValue: minimum)
    }
  }

  public static func max(_ maximum: Int) -> Validator {
    Validator(id: Identifier.max) { value in
      Rule.max(value, maximumValue: maximum)
    }
  }
}

extension Validator where Value == Bool? {
  public static let requiredTrue = Validator(Rule.requiredTrue)
}

private struct Rule {
  // TODO: Replace the email pattern
  /// @SeeAlso [this commit](https://github.com/angular/angular.js/commit/f3f5cf72e)
  /// /^(?=.{1,254}$)(?=.{1,64}@)[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

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
