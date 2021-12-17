### `fetchContacts(withGroupIdentifier:keysToFetch:)`

```swift
public func fetchContacts(withGroupIdentifier groupIdentifier: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

To fetch contacts matching group identifier
- Parameters:
  - groupIdentifier: The group identifier to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| groupIdentifier | The group identifier to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |