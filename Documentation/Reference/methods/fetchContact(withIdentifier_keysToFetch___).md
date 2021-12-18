### `fetchContact(withIdentifier:keysToFetch:_:)`

```swift
public func fetchContact(withIdentifier identifier: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<CNContact, Error>) -> Void)
```

Fetch a  contact with a given identifier.
- Parameters:
  - identifier: The identifier of the contact to fetch.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: contact matching or linked to the identifier
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifier | The identifier of the contact to fetch. |
| keysToFetch | The contact fetch request that specifies the search criteria. |