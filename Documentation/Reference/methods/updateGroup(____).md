### `updateGroup(_:_:)`

```swift
public func updateGroup(_ group: CNMutableGroup, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Updates an existing group in the contact store.
- Parameters:
  - group: The group to update.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| group | The group to update. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |