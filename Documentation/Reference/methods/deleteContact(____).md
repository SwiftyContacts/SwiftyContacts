### `deleteContact(_:_:)`

```swift
public func deleteContact(_ contact: CNMutableContact, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Deletes a contact from the contact store.
- Parameters:
  - contact: Contact to be delete.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contact | Contact to be delete. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |