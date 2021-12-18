### `fetchContacts(keysToFetch:order:unifyResults:_:)`

```swift
public func fetchContacts(keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], order: CNContactSortOrder = .none, unifyResults: Bool = true, _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

Fetch all contacts from device
- Parameters:
  - keysToFetch: The contact fetch request that specifies the search criteria.
  - order: The sort order for contacts.
  - unifyResults: A Boolean value that indicates whether to return linked contacts as unified contacts.
  - completion: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| keysToFetch | The contact fetch request that specifies the search criteria. |
| order | The sort order for contacts. |
| unifyResults | A Boolean value that indicates whether to return linked contacts as unified contacts. |
| completion | returns either a success or a failure, on sucess: returns array of contacts on error: error information, if an error occurred. |