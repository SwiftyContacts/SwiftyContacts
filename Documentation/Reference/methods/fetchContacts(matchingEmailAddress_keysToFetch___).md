### `fetchContacts(matchingEmailAddress:keysToFetch:_:)`

```swift
public func fetchContacts(matchingEmailAddress emailAddress: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

Fetch contacts matching an email address.
- Parameters:
  - emailAddress: The email address to search for. Do not include a scheme (e.g., "mailto:").
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| emailAddress | The email address to search for. Do not include a scheme (e.g., “mailto:”). |
| keysToFetch | The contact fetch request that specifies the search criteria. |