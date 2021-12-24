import Combine

protocol ObjectChangeForwardable {
  var objectWillChange: ObservableObjectPublisher { get }
}

protocol AbstractFormControl {
  associatedtype Value

  var value: Value { get set }
  var validators: [Validator<Value>] { get }
  var strategy: UpdateStrategy { get }
  var errors: ValidationErrors<Value> { get }
  var isValid: Bool { get }
  var isInvalid: Bool { get }

  func updateValidity()
}

public class FormControl<Value>: AbstractFormControl, ObservableObject, ObjectChangeForwardable {
  @Published public var value: Value {
    didSet {
      updateValidity(strategy.updateOnChange)
    }
  }
  @Published public private(set) var errors: ValidationErrors<Value>
  @Published public private(set) var isValid: Bool
  @Published public private(set) var isInvalid: Bool

  public private(set) var validators: [Validator<Value>]
  public private(set) var strategy: UpdateStrategy

  public init(
    _ value: Value,
    validators: [Validator<Value>] = [],
    strategy: UpdateStrategy = .default
  ) {
    self.value = value
    self.validators = validators
    self.strategy = strategy

    self.isValid = false
    self.isInvalid = false
    self.errors = .init()

    updateValidity(strategy.updateOnInit)
  }

  private func updateValidity(_ isUpdateEnabled: Bool) {
    if isUpdateEnabled {
      updateValidity()
    }
  }

  /// Recalculates validation status of the control.
  public func updateValidity() {
    isValid = validators.reduce(true) { previousValidity, validator in
      let currentValidity = validator.fn(value)
      errors.update(for: validator, value: currentValidity)

      return previousValidity && currentValidity
    }
    isInvalid = !isValid
  }
}
