Pod::Spec.new do |s|
 s.name = 'SwiftyContacts'
 s.version = '3.0.8'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A Swift library for Contacts framework.'
 s.homepage = 'https://github.com/satishbabariya/SwiftyContacts'
 s.authors = { "Satish Babariya" => "satish.babariya@gmail.com" }
 s.source = { :git => 'https://github.com/satishbabariya/SwiftyContacts.git', :tag => s.version.to_s }
 s.platforms = { :ios => "9.0", :osx => "10.12", :watchos => "3.0" }
 s.requires_arc = true
 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift"
     ss.framework  = "Foundation" ,"Contacts"
 end

end
