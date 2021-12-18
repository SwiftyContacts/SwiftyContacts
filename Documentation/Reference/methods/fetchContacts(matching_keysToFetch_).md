### `fetchContacts(matching:keysToFetch:)`

```swift
public func fetchContacts(matching phoneNumber: CNPhoneNumber, keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()]) throws -> [CNContact]
```

Fetch contacts matching a phone number.
- Parameters:
  - phoneNumber: A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., "tel:").
  - keysToFetch: The contact fetch request that specifies the search criteria.
- Throws: Error information, if an error occurred.
- Returns: Array  of contacts

#### Parameters

| Name | Description |
| ---- | ----------- |
| phoneNumber | A CNPhoneNumber representing the phone number to search for. Do not include a scheme (e.g., “tel:”). |
| keysToFetch | The contact fetch request that specifies the search criteria. |