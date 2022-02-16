import SwiftUI
import ReactiveForm

class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.email])
}

struct BasicFormControlView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.name.value)
      if form.name.errors[.required] {
        Text("Please fill a name.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email.value)
      if form.email.errors[.email] {
        Text("Please fill a valid email.").foregroundColor(.red)
      }
    }
      .navigationTitle("Basic usage")
  }
}
