### `addContact(_:to:_:)`

```swift
public func addContact(_ contact: CNContact, to group: CNGroup, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Add a new member to a group.
- Parameters:
  - contact: The new member to add to the group.
  - group: The group to add the member to.
  - completion: returns either a success or a failure,
on sucess: returns true
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contact | The new member to add to the group. |
| group | The group to add the member to. |
| completion | returns either a success or a failure, on sucess: returns true on error: error information, if an error occurred. |