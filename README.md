# ReactiveForm

[![Main workflow](https://github.com/samuraime/ReactiveForm/workflows/Main/badge.svg)](https://github.com/samuraime/ReactiveForm/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/samuraime/ReactiveForm/branch/main/graph/badge.svg?token=0X34NQ63HK)](https://codecov.io/gh/samuraime/ReactiveForm)

A reactive form that works with `SwiftUI` and takes advantage of `Combine`. Just grabbed some great ideas from [Reactive forms of Angular](https://angular.io/guide/reactive-forms).

## How to use

### Creating a form model

You can build a form using ``ObservableForm`` and ``FormControl``.

```swift
import ReactiveForm

class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.required, .email])
}
```

### Working with SwiftUI

```swift
import SwiftUI

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.name.value)
      if form.name.isDirty && form.name.errors[.required] {
        Text("Please fill a name.")
          .foregroundColor(.red)
      }
      TextField("Email", text: $form.email.value)
      if form.email.isDirty && form.email.errors[.email] {
        Text("Please fill a valid email.")
          .foregroundColor(.red)
      }
      Button(action: submit) {
        Text("Submit")
      }
      .disabled(form.isInvalid)
    }
  }

  func submit() {
    print(form)
  }
}
```

### Validating manually

You might think that performing validation every time the value changes is a bit too frequent. You can also perform validation manually at different times, such as `blur` of a text field or `submit` of a form.

Here is an example for validating on submit. 

It binds `pendingValue` of a form control to `TextField` instead of `value` and performs `updateValueAndValidity` on submit.

```swift
import SwiftUI

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.name.pendingValue)
      if form.name.errors[.required] {
        Text("Please fill a name.")
          .foregroundColor(.red)
      }
      TextField("Email", text: $form.email.pendingValue)
      if form.email.errors[.email] {
        Text("Please fill a valid email.")
          .foregroundColor(.red)
      }
      Button(action: submit) {
        Text("Submit")
      }
    }
  }

  func submit() {
    form.updateValueAndValidity()
    if form.isValid {
      print(form)
    }
  }
}
```

### `@FormField`

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
        Text("Please fill a name.")
          .foregroundColor(.red)
      }
      TextField("Email", text: $form.email)
      if form.$email.errors[.email] {
        Text("Please fill a valid email")
          .foregroundColor(.red)
      }
    }
  }
}
```

## License

[MIT](LICENSE)
