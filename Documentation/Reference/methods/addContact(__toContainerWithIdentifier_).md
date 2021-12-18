### `addContact(_:toContainerWithIdentifier:)`

```swift
public func addContact(_ contact: CNContact, toContainerWithIdentifier identifier: String? = nil) throws
```

Adds the specified contact to the contact store.
- Parameters:
  - contact: The new contact to add.
  - identifier: The container identifier to add the new contact to. Set to nil for the default container.
- Throws: Error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contact | The new contact to add. |
| identifier | The container identifier to add the new contact to. Set to nil for the default container. |