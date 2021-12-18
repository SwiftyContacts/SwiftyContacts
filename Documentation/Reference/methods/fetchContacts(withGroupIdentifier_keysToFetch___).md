### `fetchContacts(withGroupIdentifier:keysToFetch:_:)`

```swift
public func fetchContacts(withGroupIdentifier groupIdentifier: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

To fetch contacts matching group identifier
- Parameters:
  - groupIdentifier: The group identifier to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| groupIdentifier | The group identifier to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |