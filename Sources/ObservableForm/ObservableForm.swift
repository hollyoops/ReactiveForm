import Combine

open class ObservableForm: ObservableObject {
  fileprivate var cancellables: Set<AnyCancellable> = []

  public init() {
    forwardObjectWillChange(self)
  }
}

extension ObservableForm {
  func forwardObjectWillChange(_ object: Any) {
    Mirror(reflecting: object)
      .children
      .forEach(forwardObjectWillChangeIfNeeded)
  }

  /// Subscribes to `objectWillChange` of FormControl
  /// due to the nested `ObservableObject`
  private func forwardObjectWillChangeIfNeeded(
    child: Mirror.Child
  ) {
    guard let formControl = child.value as? ObjectChangeForwardable else {
      // Properties annotated by `FormField`
      forwardObjectWillChange(child.value)
      return
    }

    forward(from: formControl)
  }

  private func forward(from formControl: ObjectChangeForwardable) {
    formControl
      .objectWillChange
      .sink(receiveValue: objectWillChange.send)
      .store(in: &cancellables)
  }
}
