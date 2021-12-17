### `fetchGroups(matching:_:)`

```swift
public func fetchGroups(matching predicate: NSPredicate? = nil, _ completion: @escaping (Result<[CNGroup], Error>) -> Void)
```

Fetches all groups matching the specified predicate.
- Parameters:
  - predicate: The predicate to use to fetch the matching groups. Set predicate to nil to match all groups.
  - completion: returns either a success or a failure,
on sucess: An array of CNGroup objects that match the predicate.
on error: error information, if an error occurred.

#### Parameters

| Name | Description |
| ---- | ----------- |
| predicate | The predicate to use to fetch the matching groups. Set predicate to nil to match all groups. |
| completion | returns either a success or a failure, on sucess: An array of CNGroup objects that match the predicate. on error: error information, if an error occurred. |