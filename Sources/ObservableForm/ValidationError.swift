import Foundation

public struct ValidationErrors<Value> {
  var errors: [UUID: Bool] = [:]

  mutating func update(
    _ validator: Validator<Value>,
    value: Bool
  ) {
    errors.updateValue(!value, forKey: validator.key)
  }

  public subscript(_ validator: Validator<Value>) -> Bool {
    errors[validator.key] ?? false
  }
}
