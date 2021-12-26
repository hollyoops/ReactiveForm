import Combine

protocol Validatable {
  var isValid: Bool { get }
  var isInvalid: Bool { get }

  func updateValidity()
  func updateValueAndValidity()
}

typealias ValidatableObject = Validatable & AnyObject

protocol ObjectWillChangePublishable {
  var objectWillChange: ObservableObjectPublisher { get }
}

protocol Childable {
  func setParent(_: ValidatableObject)
}

typealias ValidatableControl = Validatable & ObjectWillChangePublishable & Childable

protocol AbstractControl: ValidatableControl, ObservableObject {
  associatedtype Value where Value: Equatable

  var value: Value { get set }
  var pendingValue: Value { get set }
  var validators: [Validator<Value>] { get }
  var errors: ValidationErrors<Value> { get }
}

typealias AbstractForm = Validatable & ObservableObject
