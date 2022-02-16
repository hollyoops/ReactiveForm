import Combine

protocol Validatable {
  var isValid: Bool { get }
  var isInvalid: Bool { get }
  var isPristine: Bool { get }
  var isDirty: Bool { get }

  func updateValueAndValidity()
//  func updateValidity()
}

protocol ValidatableControl: Validatable {
  var objectWillChange: ObservableObjectPublisher { get }
}

protocol AbstractControl: ValidatableControl, ObservableObject {
  associatedtype Value where Value: Equatable

  var value: Value { get set }
  var pendingValue: Value { get set }
  var validators: [Validator<Value>] { get }
  var errors: ValidationErrors<Value> { get }
}

typealias AbstractForm = Validatable & ObservableObject
