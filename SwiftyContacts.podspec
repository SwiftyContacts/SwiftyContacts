Pod::Spec.new do |s|
 s.name = 'SwiftyContacts'
 s.version = '4.0.0'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A Swift library for Contacts framework.'
 s.homepage = 'https://github.com/satishbabariya/SwiftyContacts'
 s.authors = { "Satish Babariya" => "satish.babariya@gmail.com" }
 s.source = { :git => 'https://github.com/satishbabariya/SwiftyContacts.git', :tag => s.version }
 s.platforms = { :ios => "13.0", :osx => "10.15", :watchos => "6.0" }
 s.swift_version = '5.5'
 s.source_files  = "Sources/SwiftyContacts/*.swift"
 s.framework  = "Foundation" ,"Contacts"
end
