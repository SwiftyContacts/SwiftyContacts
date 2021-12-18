### `fetchContact(in:keysToFetch:)`

```swift
public func fetchContact(in group: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

find the contacts that are members in the specified group.
- Parameters:
  - group: The group identifier to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Array  of contacts
- Returns: Error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| group | The group identifier to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |