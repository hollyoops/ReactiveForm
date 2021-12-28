import Combine

public class FormControl<Value: Equatable>: AbstractControl {
  @Published public var value: Value {
    didSet {
      updateValidity()
      markAsDirty()
    }
  }
  @Published public var pendingValue: Value
  @Published public private(set) var errors = ValidationErrors<Value>()
  @Published public private(set) var isValid: Bool = true {
    didSet {
      isInvalid = !isValid
    }
  }
  @Published public private(set) var isInvalid: Bool = false
  @Published public private(set) var isPristine: Bool = true {
    didSet {
      isDirty = !isPristine
    }
  }
  @Published public private(set) var isDirty: Bool = false

  private weak var parent: ValidatableObject?
  public private(set) var validators: [Validator<Value>]

  /// Creates a form control with the given value and its validators.
  public init(
    _ value: Value,
    validators: [Validator<Value>] = []
  ) {
    self.value = value
    self.pendingValue = value
    self.validators = validators

    updateValidity()
  }

  /// Synchronizes `pendingValue` to `value`
  /// and updates the validity of the control.
  public func updateValueAndValidity() {
    if pendingValue != value {
      value = pendingValue
    }
  }

  /// Recalculates validation status of the control.
  func updateValidity() {
    collectErrors()
    setValidityByErrors()
    parent?.updateValidity()
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
    markAsPristine(isOnlySelf: false)
  }

  /// Marks the control as dirty
  /// and also recalculates pristine state of its parent.
  public func markAsDirty() {
    markAsDirty(isOnlySelf: false)
  }

  func markAsPristine(isOnlySelf: Bool) {
    isPristine = true
    if !isOnlySelf {
      parent?.markAsPristine(isOnlySelf: true)
    }
  }

  func markAsDirty(isOnlySelf: Bool) {
    isPristine = false
    if !isOnlySelf {
      parent?.markAsDirty(isOnlySelf: true)
    }
  }

  func setParent(_ parent: ValidatableObject) {
    self.parent = parent
  }
}
