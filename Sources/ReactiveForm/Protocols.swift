import Combine

protocol Validatable {
  var isValid: Bool { get }
  var isInvalid: Bool { get }

  func updateValueAndValidity()
}

protocol ObjectWillChangePublishable {
  var objectWillChange: ObservableObjectPublisher { get }
}

typealias ValidatableControl = Validatable & ObjectWillChangePublishable

protocol AbstractFormControl: ValidatableControl, ObservableObject {
  associatedtype Value where Value: Equatable

  var value: Value { get set }
  var pendingValue: Value { get set }
  var validators: [Validator<Value>] { get }
  var errors: ValidationErrors<Value> { get }
}

typealias AbstractForm = Validatable & ObservableObject
