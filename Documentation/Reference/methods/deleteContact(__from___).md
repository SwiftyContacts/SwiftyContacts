### `deleteContact(_:from:_:)`

```swift
public func deleteContact(_ contact: CNContact, from group: CNGroup, _ completion: @escaping (Result<Bool, Error>) -> Void)
```

Removes a contact as a member of a group.
- Parameters:
  - contact: The contact to remove from the group membership.
  - group: The group to remove the contact from its membership.
  - completion: Error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contact | The contact to remove from the group membership. |
| group | The group to remove the contact from its membership. |
| completion | Error information, if an error occurred. |