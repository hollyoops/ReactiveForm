import Foundation

public struct Validator {
  public static func required(_ string: String) -> Bool {
    !string
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .isEmpty
  }

  public static func email(_ string: String) -> Bool {
    string.contains("@")
  }
}
