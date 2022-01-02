import Combine

/// A form with a publisher that emits before the form has changed.
///
/// The form collects all controls from its properties
/// that are marked as ``FormControl``.
///
///     class ProfileForm: ObservableForm {
///       var name = FormControl("", validators: [.required])
///       var email = FormControl("", validators: [.email])
///     }
open class ObservableForm: AbstractForm {
  /// Stores subscribers of `objectWillChange` from controls.
  private var cancellables: Set<AnyCancellable> = []
  private var controls: [ValidatableControl] = []

  /// A Boolean value indicating whether the form is valid.
  @Published public private(set) var isValid: Bool = false {
    didSet {
      isInvalid = !isValid
    }
  }

  /// A Boolean value indicating whether the form is invalid.
  @Published public private(set) var isInvalid: Bool = false

  /// A Boolean value indicating whether the form has not been changed yet.
  /// All of its controls are ``FormControl/isPristine``
  /// when the value is true.
  @Published public private(set) var isPristine: Bool = true {
    didSet {
      isDirty = !isPristine
    }
  }

  /// A Boolean value indicating whether the form has been changed.
  /// Some of its controls are ``FormControl/isDirty``
  /// when the value is true.
  @Published public private(set) var isDirty: Bool = false

  /// Creates a observable form and sets to initial state.
  public init() {
    collectControls(self)
    forwardObjectWillChangeFromControls()
    setFormAsParentOfControls()
    updateValidity()
  }

  /// Updates the validity of all controls in the form
  /// and also updates the validity of the form.
  public func updateValueAndValidity() {
    updateControlsValidity()
    updateValidity()
  }

  func updateValidity() {
    isValid = controls.allSatisfy {
      $0.isValid
    }
  }

  /// Marks the form and its child controls as pristine.
  public func markAsPristine() {
    markAsPristine(isOnlySelf: false)
  }

  /// Marks the form and its child controls as dirty.
  public func markAsDirty() {
    markAsDirty(isOnlySelf: false)
  }

  func markAsPristine(isOnlySelf: Bool) {
    isPristine = true
    if !isOnlySelf {
      controls.forEach {
        $0.markAsPristine(isOnlySelf: true)
      }
    }
  }

  func markAsDirty(isOnlySelf: Bool) {
    isPristine = false
    if !isOnlySelf {
      controls.forEach {
        $0.markAsDirty(isOnlySelf: true)
      }
    }
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
