//
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
//

@_exported import Contacts

/// Helper actor to encode and decode `CNContacts` as *vCard* objects.
/// 
public actor ContactCoder {
    
    /// Returns the vCard representation of the specified contacts.
    ///
    /// - parameter contacts: An array of contacts.
    /// - throws: Contains error information.
    /// - returns: An NSData object with the vCard representation of the contact.
    ///
    public static func encode(contacts: [CNContact]) throws -> Data {
        return try CNContactVCardSerialization.data(with: contacts)
    }
    
    /// Returns the contacts from the vCard data.
    ///
    /// - parameter data: The vCard data representing one or more contacts.
    /// - throws: Error information.
    /// - returns: An array of contacts.
    ///
    public static func decode(data: Data) throws -> [CNContact] {
        return try CNContactVCardSerialization.contacts(with: data)
    }
    
}
