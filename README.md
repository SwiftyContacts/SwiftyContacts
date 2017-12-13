# SwiftyContacts

[![Language: Swift 4](https://img.shields.io/badge/language-swift4-f48041.svg?style=flat-square)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![License](https://img.shields.io/cocoapods/l/SwiftyContacts.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Platform](https://img.shields.io/badge/platforms-iOS%209.0+%20%7C%20macOS%2010.12+%20%7C%20watchOS%203.0+-333333.svg?style=flat-square)](http://cocoapods.org/pods/SwiftyContacts)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/SwiftyContacts.svg?style=flat-square)](https://cocoapods.org/pods/SwiftyContacts)
[![RxSwift: Supported](https://img.shields.io/badge/RxSwift-Supported-f48041.svg?style=flat-square)](https://github.com/ReactiveX/RxSwift)
[![Read the Docs](https://img.shields.io/readthedocs/pip.svg?style=flat-square)](https://swiftycontacts.firebaseapp.com/)


A Swift library for Contacts framework.

- [Requirements](#requirements)
- [Installation](#installation)
- [Get started](#get-started)
- [RxSwift](#rxswift)
- [License](#license)

## Requirements

- iOS 9.0+ / Mac OS X 10.12+ /  watchOS 3.0+
- Xcode 9.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftyContacts into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'SwiftyContacts'

#or

pod 'SwiftyContacts/RxSwift'

```

For swift 3.x use

```ruby

// Swift 3.x
pod 'SwiftyContacts' , '~> 2.0.7'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SwiftyContacts into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SwiftyContacts/SwiftyContacts" ~> 3.0.8
```
### Swift Package Manager

To use SwiftyContacts as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloSwiftyContacts",
    dependencies: [
        .Package(url: "https://github.com/satishbabariya/SwiftyContacts", "3.0.8")
    ]
)
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate SwiftyContacts into your project manually.


#### Embeded Binaries

- Download the latest release from https://github.com/satishbabariya/SwiftyContacts/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `SwiftyContacts.framework`.
- And that's it!


## Get started

Import SwiftyContacts into your porject

```swift
    import SwiftyContacts
```


For requesting an access for getting contacts.
The user will only be prompted the first time access is requested.

```swift
    requestAccess { (responce) in
        if responce{
            print("Contacts Acess Granted")
        } else {
            print("Contacts Acess Denied")
        }
    }
```


Determine Status of Acess Permission

```swift
    authorizationStatus { (status) in
        switch status {
            case .authorized:
                print("authorized")
                break
            case .denied:
                print("denied")
                break
            default:
                break
        }
    }
```

Fetch Contacts 
 -- Result will be Array of CNContacts

```swift
    fetchContacts(completionHandler: { (result) in
        switch result{
            case .Success(response: let contacts):
                // Do your thing here with [CNContacts] array	 
                break
            case .Error(error: let error):
                print(error)
            break
        }
    })
```

Fetch Contacts by Order
-- Sorted by CNContactSortOrder
-- Result will be Array of CNContacts

```swift
    fetchContacts(ContactsSortorder: .givenName) { (result) in
        switch result{
            case .Success(response: let contacts):
                // Do your thing here with [CNContacts] array
                break
            case .Error(error: let error):
                print(error)
                break
        }
    })
```

Fetch Contacts on Background Thread

```swift
    fetchContactsOnBackgroundThread(completionHandler: { (result) in
        switch result{
            case .Success(response: let contacts):
                // Do your thing here with [CNContacts] array	 
                break
            case .Error(error: let error):
                print(error)
                break
        }
    })
```

Search Contact

```swift

    searchContact(SearchString: "john") { (result) in
        switch result{
            case .Success(response: let contacts):
                // Contacts Array includes Search Result Contacts
                break
            case .Error(error: let error):
                print(error)
                break
        }
    }

```

Get CNContact From Identifire

```swift

    getContactFromID(Identifire: "XXXXXXXXX", completionHandler: { (result) in  
        switch result{
            case .Success(response: let contact):
                // CNContact
                break
            case .Error(error: let error):
                print(error)
                break
        }
    })

```

Add Contact

```swift

    let contact : CNMutableContact = CNMutableContact()
    contact.givenName = "Satish"
    // OR Use contact.mutableCopy() For Any CNContact

    addContact(Contact: contact) { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Contact Sucessfully Added")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }

```

Add Contact in Container

```swift

    addContactInContainer(Contact: CNMutableContact, Container_Identifier: String) { (result) in
        //Same As Add Contact
    }

```

Update Contact

```swift

    updateContact(Contact: contact) { (result) in
        switch result{
        case .Success(response: let bool):
            if bool{
                print("Contact Sucessfully Updated")
            }
            break
        case .Error(error: let error):
            print(error.localizedDescription)
            break
        }
    }

```

Delete Contact

```swift
    // Use contact.mutableCopy() To convert CNContact to CNMutableContact
    deleteContact(Contact: contact) { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Contact Sucessfully Deleted")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }
```

Fetch List Of Groups

```swift
    fetchGroups { (result) in
        switch result{
            case .Success(response: let groups):
                // List Of Groups in groups array
                break
            case .Error(error: let error):
                print(error.localizedDescription)
            break
        }
    }
```

Create Group

```swift
    createGroup(Group_Name: "Satish") { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Group Sucessfully Created")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }
```

Create Group in Container

```swift
    createGroup(Group_Name: "Satish" , ContainerIdentifire: "ID") { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Group Sucessfully Created")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }
```

Update Group

```swift
    updateGroup(Group: group, New_Group_Name: "New Name") { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Group Sucessfully Updated")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }

```

Remove Group

```swift
    removeGroup(Group: group) { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Group Sucessfully Removed")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }

```

Fetch Contacts In Group

```swift

    fetchContactsInGorup(Group: group) { (result) in
        switch result{
            case .Success(response: let contacts):
                // Do your thing here with [CNContacts] array	 
                break
            case .Error(error: let error):
                print(error)
                break
        }
    }

// OR Use

    fetchContactsInGorup2(Group: group) { (result) in
        switch result{
            case .Success(response: let contacts):
                // Do your thing here with [CNContacts] array	 
                break
            case .Error(error: let error):
                print(error)
                break
        }
    }

```

Add Contact To Group

```swift
    addContactToGroup(Group: group, Contact: contact) { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Contact Sucessfully Added To Group")         
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }
```

Remove Contact From Group

```swift
    removeContactFromGroup(Group: group, Contact: contact) { (result) in
        switch result{
            case .Success(response: let bool):
                if bool{
                    print("Contact Sucessfully Added To Group")
                }
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }
```

Convert [CNContacts] TO CSV

```swift

    contactsToVCardConverter(contacts: ContactsArray) { (result) in
        switch result {
            case .Success(response: data):
                // Use file extension will be .vcf
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break

        }
    }

```

Convert CSV TO [CNContact]

```swift

    VCardToContactConverter(data: data) { (result) in
        switch result{
            case .Success(response: let contacts):
                // Use Contacts array as you like   
                break
            case .Error(error: let error):
                print(error.localizedDescription)
                break
        }
    }

```

Find Duplicates Contacts

```swift

    findDuplicateContacts(Contacts: contactsArray) { (duplicatesContacts) in
        //Duplicates Contacts Array 
        //Array type [Array<CNContact>]
    }


```

## RxSwift

Contacts Authorization
---

```swift

        rx_requestAccess().subscribe { (event) in
            switch event{
            case .next(let element):
                print(element)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

Fetch Contacts
---

```swift

        rx_fetchContacts().subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

Fetch Contacts By CNContactSortOrder

```swift

        rx_fetchContacts(ContactsSortorder: .givenName).subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

Search Contacts
---

```swift

        rx_searchContact(SearchString: "Satish").subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

Search Contacts with Array of Identifiers

```swift

        rx_ContactsFromIDs(SIdentifires: array).subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```



Contact Operations
---

Add new Contact.
```swift
        rx_addContact(Contact: mutableContact).subscribe { (event) in
            switch event{
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed,.next:
                //Do your thing
                break
            }
        }
```

Adds the specified contact to the contact store.
```swift
        rx_addContactInContainer(Contact: mutableContact, Container_Identifier: idString).subscribe { (event) in
            switch event{
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed,.next:
                //Do your thing
                break
            }
        }
```

Updates an existing contact in the contact store.
```swift
        rx_updateContact(Contact: mutableContact).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Deletes a contact from the contact store.
```swift
        rx_deleteContact(Contact: mutableContact).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Groups Methods
---

fetch list of Groups from the contact store.
```swift
        rx_fetchGroups().subscribe { (event) in
            switch event{
            case .next(let groups):
                //Array of groups
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                break
            }
        }
```

Adds a group to the contact store.
```swift
        rx_createGroup(Group_Name: "Work").subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Adds a group to the contact store.
```swift
        rx_createGroupInContainer(Group_Name: "Work", ContainerIdentifire: containerID).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Remove an existing group in the contact store.
```swift
        rx_removeGroup(Group: group).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Update an existing group in the contact store.
```swift
        rx_updateGroup(Group: group).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Adds a contact as a member of a group.
```swift
        rx_addContactToGroup(Group: group, Contact: contact).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Remove a contact as a member of a group.
```swift
        rx_removeContactFromGroup(Group: group, Contact: contact).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```

Fetch all contacts in a group.
```swift

        rx_fetchContactsInGorup(Group: group).subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

Converter Methods
---

Convert [CNContacts] TO CSV
```swift
        rx_contactsToVCardConverter(contacts: arrContacts).subscribe { (event) in
            switch event{
            case .next(let data):
                //Do anything.
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                break
            }
        }
```

Convert CSV TO [CNContact]
```swift

        x_VCardToContactConverter(data: data).subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

Convert Array of CNContacts to Data using NSKeyedArchiver
```swift
        rx_archiveContacts(contacts: arrContacts).subscribe { (event) in
            switch event{
            case .next(let data):
                //Do anything.
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                break
            }
        }
```

Convert Data to Array of CNContacts using NSKeyedArchiver
```swift

        rx_unarchiveConverter(data: data).subscribe { (event) in
            switch event{
            case .next(let contacts):
                print(contacts.count)
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed:
                print("completed")
                break
            }
        }

```

CoreTelephonyCheck
---

Convert CNPhoneNumber To digits
```swift
        rx_CNPhoneNumberToString(CNPhoneNumber: contact).subscribe { event in
            switch event {
            case .error(let error):
                print(error.localizedDescription)
                break
            case .completed, .next:
                // Do your thing
                break
            }
        }
```
Making a call.
```swift
    makeCall(CNPhoneNumber: number)
```

## Author

Satish Babariya, satish.babariya@gmail.com

## License

SwiftyContacts is available under the MIT license. See the LICENSE file for more info.
