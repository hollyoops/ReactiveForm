import Combine

/// A form control with a publisher that emits before the control has changed.
public class FormControl<Value: Equatable>: AbstractControl {
  /// A value that stores a pending change of the control.
  /// Assigning to the value triggers validation and pristine check.
  @Published public var value: Value {
    didSet {
      markAsDirty()
      validate()
    }
  }

  /// A value that stores a pending change of the control.
  /// Assigning to the pendingValue does not trigger validation and pristine check.
  @Published public var pendingValue: Value

  /// Validations applied to the control.
  public private(set) var validators: [Validator<Value>]

  /// Errors from the corresponding validators.
  @Published public private(set) var errors = ValidationErrors<Value>()

  /// A Boolean value indicating whether the control is valid.
  @Published public private(set) var isValid: Bool = true {
    didSet {
      isInvalid = !isValid
    }
  }

  /// A Boolean value indicating whether the control is invalid.
  @Published public private(set) var isInvalid: Bool = false

  /// A Boolean value indicating
  /// whether the ``value`` of the control has not been changed yet.
  @Published public private(set) var isPristine: Bool = true {
    didSet {
      isDirty = !isPristine
    }
  }

  /// A Boolean value indicating
  /// whether the ``value`` of the control has been changed.
  @Published public private(set) var isDirty: Bool = false

  /// Creates a form control with the provided value and its validators.
  public init(
    _ value: Value,
    validators: [Validator<Value>] = []
  ) {
    self.value = value
    self.pendingValue = value
    self.validators = validators

    validate()
  }

  /// Synchronizes `pendingValue` to `value`
  /// and updates the validity of the control.
  public func updateValueAndValidity() {
    if pendingValue != value {
      value = pendingValue
    }
  }

  /// Recalculates the validity of the control.
  func validate() {
    collectErrors()
    setValidityByErrors()
  }

  private func setValidityByErrors() {
    isValid = !errors.hasError
  }

  private func collectErrors() {
    validators.forEach {
      errors.update(for: $0, value: $0.fn(value))
    }
  }

  /// Marks the control as pristine
  /// and also recalculates pristine state of its parent.
  public func markAsPristine() {
    isPristine = true
  }

  /// Marks the control as dirty
  /// and also recalculates pristine state of its parent.
  public func markAsDirty() {
    isPristine = false
  }
}
