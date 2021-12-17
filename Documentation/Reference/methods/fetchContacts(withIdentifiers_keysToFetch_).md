### `fetchContacts(withIdentifiers:keysToFetch:)`

```swift
public func fetchContacts(withIdentifiers identifiers: [String], keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

To fetch contacts matching contact identifiers.
- Parameters:
  - identifiers: Contact identifiers to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifiers | Contact identifiers to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |