public struct UpdateStrategy: Equatable {
  var updateOnInit: Bool
  var updateOnChange: Bool

  public init(
    updateOnInit: Bool,
    updateOnChange: Bool
  ) {
    self.updateOnInit = updateOnInit
    self.updateOnChange = updateOnChange
  }
}

extension UpdateStrategy {
  public static var `default`: Self = .onlyChange

  public static let onlyChange = Self(
    updateOnInit: false,
    updateOnChange: true
  )

  public static let always = Self(
    updateOnInit: true,
    updateOnChange: true
  )

  public static let never = Self(
    updateOnInit: false,
    updateOnChange: false
  )
}
