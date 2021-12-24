# ReactiveForm

[![Main workflow](https://github.com/samuraime/ReactiveForm/workflows/Main/badge.svg)](https://github.com/samuraime/ReactiveForm/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/samuraime/ReactiveForm/branch/main/graph/badge.svg?token=U1RGM8F64E)](https://codecov.io/gh/samuraime/ReactiveForm)

A reactive form that works with SwiftUI. Just implemented some great concepts from [Reactive forms of Angular](https://angular.io/guide/reactive-forms).

## Basic usage

There are two ways to write your code, using `FormControl` directly or `@FormField`.

### `FormControl`

```swift
import ReactiveForm

class ProfileForm: ObservableForm {
  var name = FormControl("", [.required])
  var email = FormControl("", [.required, .email])
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

### `@FormField`

```swift
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
