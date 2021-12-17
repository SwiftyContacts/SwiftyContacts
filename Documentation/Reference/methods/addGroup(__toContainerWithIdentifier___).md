### `addGroup(_:toContainerWithIdentifier:_:)`

```swift
public func addGroup(_ name: String, toContainerWithIdentifier identifier: String? = nil, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Adds a group to the contact store.
- Parameters:
  - name: The new group to add.
  - identifier: The container identifier to add the new group to. Set to nil for the default container.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The new group to add. |
| identifier | The container identifier to add the new group to. Set to nil for the default container. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |