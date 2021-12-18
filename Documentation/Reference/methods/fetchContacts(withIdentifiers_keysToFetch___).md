### `fetchContacts(withIdentifiers:keysToFetch:_:)`

```swift
public func fetchContacts(withIdentifiers identifiers: [String], keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

To fetch contacts matching contact identifiers.
- Parameters:
  - identifiers: Contact identifiers to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifiers | Contact identifiers to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |