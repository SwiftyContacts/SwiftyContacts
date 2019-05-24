Pod::Spec.new do |s|
    s.name = 'SwiftyContacts'
    s.version = '0.0.1'
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.summary = 'A Swift library for Contacts framework.'
    s.homepage = 'https://github.com/satishbabariya/SwiftyContacts'
    s.authors = { "Satish Babariya" => "satish.babariya@gmail.com" }
    s.source = { :git => 'https://github.com/satishbabariya/SwiftyContacts.git', :tag => s.version }
    s.platforms = { :ios => "10.0", :osx => "10.12", :watchos => "3.0" }
    s.swift_version = '5.0'
    s.source_files  = "Sources/SwiftyContacts/*.swift"
    s.framework  = "Foundation" ,"Contacts"
   
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '10.0'
   
   end
   