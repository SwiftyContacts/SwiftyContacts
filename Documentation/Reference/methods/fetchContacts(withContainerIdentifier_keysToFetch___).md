### `fetchContacts(withContainerIdentifier:keysToFetch:_:)`

```swift
public func fetchContacts(withContainerIdentifier containerIdentifier: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

find the contacts in the specified container.
- Parameters:
  - containerIdentifier: The container identifier to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| containerIdentifier | The container identifier to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |