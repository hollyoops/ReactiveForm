@propertyWrapper
public struct FormField<Value> {
  private var value: Value

  public private(set) var projectedValue: FormControl<Value>

  public var wrappedValue: Value {
    get {
      value
    }
    set {
      value = newValue
      projectedValue.value = newValue
    }
  }

  public init(
    wrappedValue value: Value,
    validators: [Validator<Value>] = [],
    strategy: UpdateStrategy = .default
  ) {
    self.value = value
    self.projectedValue = .init(
      value,
      validators: validators,
      strategy: strategy
    )
  }
}
