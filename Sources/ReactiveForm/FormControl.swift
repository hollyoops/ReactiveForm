import Combine

public class FormControl<Value: Equatable>: AbstractFormControl {
  @Published public var value: Value {
    didSet {
      updateValidity()
    }
  }
  @Published public var pendingValue: Value
  @Published public private(set) var errors: ValidationErrors<Value>
  @Published public private(set) var isValid: Bool
  @Published public private(set) var isInvalid: Bool

  public private(set) var validators: [Validator<Value>]

  public init(
    _ value: Value,
    validators: [Validator<Value>] = []
  ) {
    self.value = value
    self.pendingValue = value
    self.validators = validators

    self.isValid = false
    self.isInvalid = false
    self.errors = .init()

    updateValidity()
  }

  public func updateValueAndValidity() {
    if pendingValue != value {
      value = pendingValue
    }
  }

  /// Recalculates validation status of the control.
  private func updateValidity() {
    isValid = validators.reduce(true) { previousValidity, validator in
      let currentValidity = validator.fn(value)
      errors.update(for: validator, value: currentValidity)

      return previousValidity && currentValidity
    }
    isInvalid = !isValid
  }
}
