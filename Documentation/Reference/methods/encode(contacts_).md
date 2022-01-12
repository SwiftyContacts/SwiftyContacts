### `encode(contacts:)`

```swift
public func encode(contacts: [CNContact]) throws -> Data
```

Returns the vCard representation of the specified contacts.
- Parameter contacts: An array of contacts.
- Throws: Contains error information.
- Returns: An NSData object with the vCard representation of the contact.

#### Parameters

| Name | Description |
| ---- | ----------- |
| contacts | An array of contacts. |