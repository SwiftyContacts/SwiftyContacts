### `deleteGroup(_:_:)`

```swift
public func deleteGroup(_ group: CNMutableGroup, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Deletes a group from the contact store.
- Parameters:
  - group: The group to delete.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| group | The group to delete. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |