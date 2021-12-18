### `fetchContacts(matchingName:keysToFetch:_:)`

```swift
public func fetchContacts(matchingName name: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

fetch contacts matching a name.
- Parameters:
  - name: The name can contain any number of words.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name can contain any number of words. |
| keysToFetch | The contact fetch request that specifies the search criteria. |