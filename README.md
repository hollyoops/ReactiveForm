# ReactiveForm

[![Main workflow](https://github.com/samuraime/ReactiveForm/workflows/Main/badge.svg)](https://github.com/samuraime/ReactiveForm/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/samuraime/ReactiveForm/branch/main/graph/badge.svg?token=U1RGM8F64E)](https://codecov.io/gh/samuraime/ReactiveForm)

A reactive form that works with `SwiftUI` and takes advantage of `Combine`. Just grabbed some great ideas from [Reactive forms of Angular](https://angular.io/guide/reactive-forms).

## Basic usage

Use `ObservableForm` and `FormControl` to build a form.

```swift
import SwiftUI
import ReactiveForm

class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.required, .email])
}

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.firstName.value)
      if form.name.errors[.required] {
        Text("Please fill a name.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email.value)
      if form.email.errors[.email] {
        Text("Please fill a valid email").foregroundColor(.red)
      }
    }
  }
}
```

Additionally, there is `@FormField` for the fans of property wrapper. Its `projectedValue` is just `FormControl`. The code in View is a little bit different from the example above. Please note the position of `$`. 

```swift
import SwiftUI
import ReactiveForm

class ProfileForm: ObservableForm {
  @FormField(validators: [.required])
  var name = ""
  
  @FormField(validators: [.required, .email])
  var email = ""
}

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.firstName)
      if form.$name.errors[.required] {
        Text("Please fill a name.").foregroundColor(.red)
      }
      TextField("Email", text: $form.email)
      if form.$email.errors[.email] {
        Text("Please fill a valid email").foregroundColor(.red)
      }
    }
  }
}
```

## License

[MIT](LICENSE)
