### `fetchContacts(matchingEmailAddress:keysToFetch:)`

```swift
public func fetchContacts(matchingEmailAddress emailAddress: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

Fetch contacts matching an email address.
- Parameters:
  - emailAddress: The email address to search for. Do not include a scheme (e.g., "mailto:").
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| emailAddress | The email address to search for. Do not include a scheme (e.g., “mailto:”). |
| keysToFetch | The contact fetch request that specifies the search criteria. |