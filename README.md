# ReactiveForm

[![Main workflow](https://github.com/hollyoops/ReactiveForm/workflows/Main/badge.svg)](https://github.com/hollyoops/ReactiveForm/actions/workflows/main.yml) [![codecov](https://codecov.io/gh/hollyoops/ReactiveForm/branch/main/graph/badge.svg?token=0X34NQ63HK)](https://codecov.io/gh/hollyoops/ReactiveForm)

A flexible and extensible forms with easy-to-use validation. This library build for `SwiftUI` and inspired by [Reactive forms of Angular](https://angular.io/guide/reactive-forms).

## Installation

- [**Swift Package Manager**](https://swift.org/package-manager/)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/hollyoops/ReactiveForm.git`) and finish import

- [**CocoaPods**](https://cocoapods.org) 

RecoilSwift is available through CocoaPods. To install it, simply add the following line to your Podfile:

```ruby
pod 'ReactiveForm'
```

## Usage

### Define fields with property wrapper

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
      if form.$name.isInValid {
        Text("Please fill a name.")
          .foregroundColor(.red)
      }
      TextField("Email", text: $form.email)
      if form.$email.isInValid {
        Text("Please fill a valid email")
          .foregroundColor(.red)
      }
    }
  }
}
```

### Customize validator

```swift
let stringValidator = Validator { stringValue: String -> Bool
  // some check logic
  return true
}

class ProfileForm: ObservableForm {
  @FormField(validators: [.required, stringValidator])
  var name = ""
}
```

### Creating a form model

You are are not a big fan of property wrapper, you can build a form using ``ObservableForm`` and ``FormControl``.

```swift
import ReactiveForm

class ProfileForm: ObservableForm {
  var name = FormControl("", validators: [.required])
  var email = FormControl("", validators: [.required, .email])
}
```

### Validating manually

For some case, you may need to manually call `validate` rather than validate on change


```swift
class ProfileForm: ObservableForm {
  @FormField("", validators: [.required], type: .manually) 
  var name: String

  @FormField("", validators: [.email], type: .manually) 
  var email: String
}

struct ContentView: View {
  @StateObject var form = ProfileForm()

  var body: some View {
    Form {
      TextField("Name", text: $form.name.pendingValue)
      if form.$name.errors[.required] {
        Text("Please fill a name.")
          .foregroundColor(.red)
      }
      TextField("Email", text: $form.email.pendingValue)
      if form.$email.errors[.email] {
        Text("Please fill a valid email.")
          .foregroundColor(.red)
      }
      Button(action: submit) {
        Text("Submit")
      }
    }
  }

  func submit() {
    form.validate()
    if form.isValid {
      print(form)
    }
  }
}
```

### Use Dirty to check form status

You can use `isDirty` & `isPristine` to check where form is edited. 

One possible scenario is when page appear you don't want to show error util form is edited.

```swift
class SettingsForm: ObservableForm {
  var name = FormControl("", validators: [.required], type: .manually) 

  var email = FormControl("", validators: [.email], type: .manually) 
}

struct ContentView: View {
  @StateObject var form = SettingsForm()

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
}
```

## Documentation

[![Netlify Status](https://api.netlify.com/api/v1/badges/7593e5fb-308e-4a64-9947-8267a9f7a556/deploy-status)](https://app.netlify.com/sites/frosty-yonath-df6e87/deploys)

The APIs are written by [DocC](https://developer.apple.com/documentation/docc), you can build it in your Xcode or see [the online version](https://frosty-yonath-df6e87.netlify.app/documentation/).

## License

[MIT](LICENSE)
