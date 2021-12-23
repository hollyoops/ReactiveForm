# ReactiveForm

Swift version of Reactive form, just like [Reactive forms of Angular](https://angular.io/guide/reactive-forms)

## Basic usage

```swift
import ReactiveForm

class ProfileForm: ObservableForm {
  @FormField(validators: [.required])
  var name: String = ""
  
  @FormField(validators: [.required, .email])
  var email: String = ""
  
  @FormField
  var location: String = ""
}

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Nickname", text: $form.firstName)
      if form.$firstName.errors[.required] {
        Text("Please fill a nickname.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email)
      if form.$email.errors[.email] {
        Text("Please enter a valid email").foregroundColor(.red)
      }
    }
  }
}
```

```swift
import ReactiveForm

class ProfileForm: ObservableForm {
  var name = FormControl("", [.required])
  var email = FormControl("", [.required, .email])
  var location = FormControl("")
}

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Nickname", text: $form.firstName.value)
      if form.firstName.errors[.required] {
        Text("Please fill a name.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email.value)
      if form.email.errors[.email] {
        Text("Please enter a valid email").foregroundColor(.red)
      }
    }
  }
}
```
