### `fetchContact(in:keysToFetch:_:)`

```swift
public func fetchContact(in group: String, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

find the contacts that are members in the specified group.
- Parameters:
  - group: The group identifier to be matched.
  - keysToFetch: The contact fetch request that specifies the search criteria.
  - completion: returns either a success or a failure,
on sucess: Array  of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| group | The group identifier to be matched. |
| keysToFetch | The contact fetch request that specifies the search criteria. |
| completion | returns either a success or a failure, on sucess: Array  of contacts on error: error information, if an error occurred. |