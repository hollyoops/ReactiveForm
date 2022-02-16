import SwiftUI
import ReactiveForm

class ProfileFormOnSubmit: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.email])
}

struct ValidateOnSubmitView: View {
  @StateObject var form = ProfileFormOnSubmit()

  var body: some View {
    Form {
      TextField("Name", text: $form.name.pendingValue)
      if form.name.errors[.required] {
        Text("Please fill a name.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email.pendingValue)
      if form.email.errors[.email] {
        Text("Please fill a valid email.").foregroundColor(.red)
      }
      Button(action: submit) {
        Text("Submit")
      }
    }
      .navigationTitle("Validate on submit")
  }

  func submit() {
    form.updateValueAndValidity()
    if form.isValid {
      print(form)
    }
  }
}
