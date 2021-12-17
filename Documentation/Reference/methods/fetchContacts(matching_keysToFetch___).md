### `fetchContacts(matching:keysToFetch:_:)`

```swift
public func fetchContacts(matching phoneNumber: CNPhoneNumber, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], _ completion: @escaping (Result<[CNContact], Error>) -> Void)
```

Fetch contacts matching a phone number.
- Parameters:
  - phoneNumber: A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., "tel:").
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Returns: returns either a success or a failure,
on sucess: returns array of contacts
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| phoneNumber | A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., “tel:”). |
| keysToFetch | The contact fetch request that specifies the search criteria. |