import SwiftUI
  // value of customization changes

struct ContentView: View {
  var body: some View {
    List {
      NavigationLink(
        "Basic usage with FormControl",
        destination: BasicFormControlView()
      )
      NavigationLink(
        "Basic usage with @FormField",
        destination: BasicFormFieldView()
      )
      NavigationLink(
        "Validate on Change",
        destination: ValidateOnChangeView()
      )
      NavigationLink(
        "Validate on Submit",
        destination: ValidateOnSubmitView()
      )
    }
    .navigationTitle("Examples")
  }
}
