### `requestAccess(_:)`

```swift
public func requestAccess(_ completion: @escaping (Result<Bool, Error>) -> Void)
```

Requests access to the user's contacts.
- Parameter completion: returns either a success or a failure,
on sucess: returns true if the user allows access to contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | returns either a success or a failure, on sucess: returns true if the user allows access to contacts on error: error information, if an error occurred. |