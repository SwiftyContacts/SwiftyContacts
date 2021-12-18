### `fetchContacts(predicate:keysToFetch:_:)`

```swift
public func fetchContacts(predicate: NSPredicate, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

fetch contacts matching a conditions.
- Parameters:
  - predicate: A definition of logical conditions for constraining a search for a fetch or for in-memory filtering.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | A definition of logical conditions for constraining a search for a fetch or for in-memory filtering. |
| keysToFetch | The contact fetch request that specifies the search criteria. |