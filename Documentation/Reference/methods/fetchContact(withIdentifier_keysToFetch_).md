### `fetchContact(withIdentifier:keysToFetch:)`

```swift
public func fetchContact(withIdentifier identifier: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> CNContact
```

Fetch a  contact with a given identifier.
- Parameters:
  - identifier: The identifier of the contact to fetch.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Contact matching or linked to the identifier

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifier | The identifier of the contact to fetch. |
| keysToFetch | The contact fetch request that specifies the search criteria. |