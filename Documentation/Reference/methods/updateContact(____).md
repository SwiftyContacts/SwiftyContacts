### `updateContact(_:_:)`

```swift
public func updateContact(_ contact: CNMutableContact, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Updates an existing contact in the contact store.
- Parameters:
  - contact: The contact to update.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contact | The contact to update. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |