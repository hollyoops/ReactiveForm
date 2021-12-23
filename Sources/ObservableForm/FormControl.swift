import Combine

protocol ObjectChangeForwardable {
  var objectWillChange: ObservableObjectPublisher { get }
}

protocol AbstractFormControl {
  associatedtype Value

  var value: Value { get set }
  var errors: ValidationErrors<Value> { get }
  var isValid: Bool { get }
  var isInvalid: Bool { get }
}

public class FormControl<Value>: AbstractFormControl, ObservableObject, ObjectChangeForwardable {
  public typealias ControlValidator = Validator<Value>

  @Published public var value: Value {
    willSet {
      updateComputedProperties(newValue)
    }
  }
  @Published public private(set) var errors: ValidationErrors<Value>
  @Published public private(set) var isValid: Bool
  @Published public private(set) var isInvalid: Bool

  private var validators: [ControlValidator]

  public init(_ value: Value, validators: [ControlValidator]) {
    self.value = value
    self.validators = validators
    self.isValid = false
    self.isInvalid = false
    self.errors = .init()
    self.updateComputedProperties(value)
  }

  private func updateComputedProperties(_ newValue: Value) {
    isValid = validators.reduce(true) { previousValue, validator in
      let currentValue = validator.fn(newValue)
      errors.update(validator, value: currentValue)
      return previousValue && currentValue
    }
    isInvalid = !isValid
  }
}
