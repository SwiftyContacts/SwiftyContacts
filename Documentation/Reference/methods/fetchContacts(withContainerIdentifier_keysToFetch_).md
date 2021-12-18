### `fetchContacts(withContainerIdentifier:keysToFetch:)`

```swift
public func fetchContacts(withContainerIdentifier containerIdentifier: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

find the contacts in the specified container.
- Parameters:
  - containerIdentifier: The container identifier to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| containerIdentifier | The container identifier to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |