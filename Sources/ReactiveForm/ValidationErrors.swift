import Foundation

/// Validation errors of a form.
public struct ValidationErrors<Value> {
  var errors: [UUID: Bool] = [:]

  var hasError: Bool {
    errors.contains { $0.value }
  }

  mutating func update(
    for validator: Validator<Value>,
    value: Bool
  ) {
    errors.updateValue(!value, forKey: validator.id)
  }

  /// Gets whether there is an error with the provided validator.
  public subscript(_ validator: Validator<Value>) -> Bool {
    errors[validator.id] ?? false
  }
}
