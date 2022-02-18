Pod::Spec.new do |s|
  s.name             = 'ReactiveForm'
  s.version          = '0.2.0'
  s.summary          = 'ReactiveForm is for managing data and validation in SwiftUI'

  s.description      = <<-DESC
  A flexible and extensible forms with easy-to-use validation
                       DESC

  s.homepage         = 'https://github.com/hollyoops/ReactiveForm'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hcli@thoughtworks.com' => 'hcli@thoughtworks.com' }
  s.source           = { :git => 'https://github.com/hollyoops/ReactiveForm.git', :tag => s.version.to_s }

  s.platform = :ios, '13.0'

  s.source_files = 'Sources/**/*.swift'
  s.swift_version = '5'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*Tests.Swift'
  end
end
