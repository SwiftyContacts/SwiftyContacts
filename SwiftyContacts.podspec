Pod::Spec.new do |s|
 s.name = 'SwiftyContacts'
 s.version = '5.0.0'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A modern Swift library for Contacts framework with async/await support.'
 s.description = <<-DESC
 SwiftyContacts is a modern Swift library that provides a clean, type-safe interface to the Contacts framework.
 It supports both async/await and closure-based APIs, making it easy to work with contacts on iOS, macOS, watchOS, and tvOS.
 DESC
 s.homepage = 'https://github.com/SwiftyContacts/SwiftyContacts'
 s.authors = { "Satish Babariya" => "satish.babariya@gmail.com" }
 s.source = { :git => 'https://github.com/SwiftyContacts/SwiftyContacts.git', :tag => s.version }
 s.platforms = { 
   :ios => "15.0", 
   :osx => "12.0",
   :watchos => "8.0",
   :tvos => "15.0"
 }
 s.swift_version = '5.9'
 s.source_files  = "Sources/SwiftyContacts/*.swift"
 s.framework  = "Foundation", "Contacts"
end
