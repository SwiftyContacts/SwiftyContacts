### `addContact(_:toContainerWithIdentifier:_:)`

```swift
public func addContact(_ contact: CNMutableContact, toContainerWithIdentifier identifier: String? = nil, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Adds the specified contact to the contact store.
- Parameters:
  - contact: The new contact to add.
  - identifier: The container identifier to add the new contact to. Set to nil for the default container.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contact | The new contact to add. |
| identifier | The container identifier to add the new contact to. Set to nil for the default container. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |