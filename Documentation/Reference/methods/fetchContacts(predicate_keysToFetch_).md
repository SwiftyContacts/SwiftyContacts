### `fetchContacts(predicate:keysToFetch:)`

```swift
public func fetchContacts(predicate: NSPredicate, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

fetch contacts matching a conditions.
- Parameters:
  - predicate: A definition of logical conditions for constraining a search for a fetch or for in-memory filtering.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | A definition of logical conditions for constraining a search for a fetch or for in-memory filtering. |
| keysToFetch | The contact fetch request that specifies the search criteria. |