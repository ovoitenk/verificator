# verificator
iOS Verificator SDK sample. Scan strings from ID card and verify selfies. 

### iOS SDK Requirements

Integration Verificator iOS SDK requires at least iOS version 13.0

### Adding the SDK to the project

Manually copy `oleg-verificator-sdk` directory into your project. Then add `VerificatorSDK` in Project -> General -> Frameworks, Libraries, and Embedded Content.

### Adding permissions

Add usage description for `NSCameraUsageDescription` application Info.plist. Not adding this description will lead to killing the application on SDK session start. 

### Starting verification flow

#### Import Verificator
`import VerificatorSDK`

#### Start reading text from ID card
```
Verificator.startCardIdReading { (result) in

}
```
where `result` is `VerificatorStatus<[String]>`

SDK returns array of strings for happy path.
#### Start selfie verification
```
Verificator.startSelfieTaking { (result) in

}
```
where `result` is `VerificatorStatus<Double>`

SDK returns face confidence level for happy path.

### Customizing configuration (Optional)
```
let configuration = VerificatorConfiguration(tintColor: UIColor.red, errorHandlingMode: .manual)
Verificator.configure(configuration: configuration)
```
`tintColor` - Tint color for the active elements (aka buttons). Default #4FB1A9

`errorHandlingMode` - Specifies error handling mode. Automatic by default.

#### VeritificatorErrorHandlingMode
`automatic` - SDK handles errors by itself and displays appropriate messages. VerificatorStatus.error is never sent.

`manual` - SDK invokes callback in case of an error. It is up to the appliation to handle errors.
