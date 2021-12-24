import Foundation

public struct Validator<Value> {
  public typealias ValidatorFn = (Value) -> Bool

  var key = UUID()
  var fn: ValidatorFn

  public init(_ fn: @escaping ValidatorFn) {
    self.fn = fn
  }
}

extension Validator: Equatable {
  public static func == (lhs: Validator<Value>, rhs: Validator<Value>) -> Bool {
    lhs.key == rhs.key
  }
}

extension Validator where Value == String {
  public static let required = Validator(Rule.required)
  public static let email = Validator(Rule.email)
}

private struct Rule {
  static func required(_ string: String) -> Bool {
    !string
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .isEmpty
  }

  static func email(_ string: String) -> Bool {
    string.contains("@")
  }
}
