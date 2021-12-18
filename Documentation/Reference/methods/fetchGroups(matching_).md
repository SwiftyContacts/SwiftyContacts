### `fetchGroups(matching:)`

```swift
public func fetchGroups(matching predicate: NSPredicate? = nil) throws -> [CNGroup]
```

Fetches all groups in the contact store.
- Parameter predicate: The predicate to use to fetch the matching groups. Set predicate to nil to match all groups.
- Throws: Error information, if an error occurred.
- Returns: An array of CNGroup objects that match the predicate.

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | The predicate to use to fetch the matching groups. Set predicate to nil to match all groups. |