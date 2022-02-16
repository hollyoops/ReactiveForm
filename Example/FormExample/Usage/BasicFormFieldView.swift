import SwiftUI
import ReactiveForm

class SettingForm: ObservableForm {
  @FormField(validators: [.required])
  var firstName: String = ""

  @FormField(validators: [.email])
  var email: String = ""
}

struct BasicFormFieldView: View {
  @StateObject var form = SettingForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.firstName)
      if form.$firstName.errors[.required] {
        Text("Please fill a name.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email)
      if form.$email.errors[.email] {
        Text("Please fill a valid email.").foregroundColor(.red)
      }
    }
      .navigationTitle("Basic usage with @FormField")
  }
}
