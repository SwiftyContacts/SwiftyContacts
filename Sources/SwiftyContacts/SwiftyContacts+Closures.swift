//    Copyright (c) 2022 Satish Babariya <satish.babariya@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

@_exported import Contacts

/// Requests access to the user's contacts.
/// - Parameter completion: returns either a success or a failure,
/// on sucess: returns true if the user allows access to contacts
/// on error: error information, if an error occurred.
public func requestAccess(_ completion: @escaping (Result<Bool, Error>) -> Void) {
    ContactStore.default.requestAccess(for: .contacts) { bool, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        completion(.success(bool))
    }
}

/// Fetch all contacts from device
/// - Parameters:
///   - keysToFetch: The contact fetch request that specifies the search criteria.
///   - order: The sort order for contacts.
///   - unifyResults: A Boolean value that indicates whether to return linked contacts as unified contacts.
///   - completion: returns either a success or a failure,
/// on sucess: returns array of contacts
/// on error: error information, if an error occurred.
///
public func fetchContacts(keysToFetch: [CNKeyDescriptor] = [CNContactVCardSerialization.descriptorForRequiredKeys()], order: CNContactSortOrder = .none, unifyResults: Bool = true, _ completion: @escaping (Result<[CNContact], Error>) -> Void) {
    do {
        var contacts: [CNContact] = []
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.unifyResults = unifyResults
        fetchRequest.sortOrder = order
        try ContactStore.default.enumerateContacts(with: fetchRequest) { contact, _ in
            contacts.append(contact)
        }
        completion(.success(contacts))
    } catch {
        completion(.failure(error))
    }
}
