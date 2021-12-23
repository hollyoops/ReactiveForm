import Combine

protocol ObjectChangeForwardable {
  var objectWillChange: ObservableObjectPublisher { get }
}

protocol AbstractFormControl {
  associatedtype Value

  var value: Value { get set }
  var isValid: Bool { get }
}

public class FormControl<Value>: AbstractFormControl, ObservableObject, ObjectChangeForwardable {
  public typealias Validator = (Value) -> Bool

  @Published public var value: Value {
    willSet {
      updateComputedProperties(newValue)
    }
  }
  @Published public private(set) var isValid: Bool = true

  private var validators: [Validator]

  public init(_ value: Value, validators: [Validator]) {
    self.value = value
    self.validators = validators
  }

  private func updateComputedProperties(_ newValue: Value) {
    isValid = validators.allSatisfy { $0(newValue) }
  }
}
