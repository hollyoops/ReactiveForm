import Combine

/// A form with a publisher that emits before the form has changed.
///
///     class ProfileForm: ObservableForm {
///       var name = FormControl("", validators: [.required])
///       var email = FormControl("", validators: [.email])
///     }
open class ObservableForm: AbstractForm {
  /// Stores subscribers of `objectWillChange` from controls.
  private var cancellables: Set<AnyCancellable> = []
  private var controls: [ValidatableControl] = []

  @Published public private(set) var isValid: Bool = false
  @Published public private(set) var isInvalid: Bool = false

  public init() {
    collectControls(self)
    forwardObjectWillChangeFromControls()
    setFormAsParentOfControls()
    updateValidity()
  }

  /// Updates the validity of all controls in the form,
  /// also updates the validity of the form.
  public func updateValueAndValidity() {
    updateControlsValidity()
    updateValidity()
  }

  func updateValidity() {
    isValid = controls.allSatisfy {
      $0.isValid
    }

    isInvalid = !isValid
  }
}

private extension ObservableForm {
  func collectControls(_ object: Any) {
    Mirror(reflecting: object)
      .children
      .forEach(collectControlIfPossible)
  }

  func collectControlIfPossible(child: Mirror.Child) {
    guard let control = child.value as? ValidatableControl else {
      // Properties annotated by `FormField`
      collectControls(child.value)
      return
    }

    controls.append(control)
  }

  func forwardObjectWillChangeFromControls() {
    controls.forEach(forward(from:))
  }

  /// Forwards `objectWillChange` of FormControl
  /// due to the nested `ObservableObject`.
  func forward(from control: ValidatableControl) {
    control
      .objectWillChange
      .sink(receiveValue: objectWillChange.send)
      .store(in: &cancellables)
  }

  func updateControlsValidity() {
    controls.forEach {
      $0.updateValueAndValidity()
    }
  }

  func setFormAsParentOfControls() {
    controls.forEach {
      $0.setParent(self)
    }
  }
}
