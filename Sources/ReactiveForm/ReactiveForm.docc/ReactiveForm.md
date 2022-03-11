# ``ReactiveForm``

A reactive form that works with `SwiftUI` and takes advantage of `Combine`.

## Overview

The ReactiveForm grabbed great ideas from [Reactive forms of Angular](https://angular.io/guide/reactive-forms). It also allows you to:

- Capture the current value and validation status of a form.
- Track and listen for changes to the form's data model.
- Validate the correctness.
- Create custom validators.

### Basic usage

You can build a form model using ``ObservableForm`` and ``FormControl``.

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

It binds `pendingValue` of a form control to `TextField` instead of `value` and performs `flushPendingValue` on submit.

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
    form.flushPendingValue()
    if form.isValid {
      print(form)
    }
  }
}
```

## Topics

### Form

- ``ObservableForm``
- ``FormControl``
- ``FormField``

### Validation

- ``Validator``
- ``ValidationErrors``
