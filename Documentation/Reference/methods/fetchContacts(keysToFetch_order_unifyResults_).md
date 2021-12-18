### `fetchContacts(keysToFetch:order:unifyResults:)`

```swift
public func fetchContacts(keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], order: CNContactSortOrder = .none, unifyResults: Bool = true) async throws -> [CNContact]
```

Fetch all contacts from device
- Parameters:
  - keysToFetch: The contact fetch request that specifies the search criteria.
  - order: The sort order for contacts.
  - unifyResults: A Boolean value that indicates whether to return linked contacts as unified contacts.
- Throws: Error information, if an error occurred.
- Returns: array of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| keysToFetch | The contact fetch request that specifies the search criteria. |
| order | The sort order for contacts. |
| unifyResults | A Boolean value that indicates whether to return linked contacts as unified contacts. |