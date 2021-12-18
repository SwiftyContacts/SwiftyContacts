### `fetchContacts(matchingName:keysToFetch:)`

```swift
public func fetchContacts(matchingName name: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

fetch contacts matching a name.
- Parameters:
  - name: The name can contain any number of words.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name can contain any number of words. |
| keysToFetch | The contact fetch request that specifies the search criteria. |