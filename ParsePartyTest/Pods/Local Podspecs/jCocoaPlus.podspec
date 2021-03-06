#
#  Be sure to run `pod spec lint jCocoaPlus.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

	# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  These will help people to find your library, and whilst it
	#  can feel like a chore to fill in it's definitely to your advantage. The
	#  summary should be tweet-length, and the description more in depth.
	#

	s.name         = "jCocoaPlus"
	s.version      = "0.0.1"
	s.summary      = "A short description of jCocoaPlus."

	s.description  = <<-DESC
	A longer description of jCocoaPlus in Markdown format.

	* Think: Why did you write this? What is the focus? What does it do?
	* CocoaPods will be using this to generate tags, and improve search results.
	* Try to keep it short, snappy and to the point.
	* Finally, don't worry about the indent, CocoaPods strips it!
	DESC

	s.homepage     = "https://github.com/zakdances/jCocoaPlus"
	# s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"


	# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  Licensing your code is important. See http://choosealicense.com for more info.
	#  CocoaPods will detect a license file if there is a named LICENSE*
	#  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
	#

	s.license      = 'MIT'
	# s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }


	# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  Specify the authors of the library, with email addresses. Email addresses
	#  of the authors by using the SCM log. E.g. $ git log. If no email can be
	#  found CocoaPods accept just the names.
	#

	s.author       = "Zak"
	# s.authors      = { "Zak" => "zakdances@gmail.com", "other author" => "email@address.com" }
	# s.author       = 'Zak', 'other author'


	# ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  If this Pod runs only on iOS or OS X, then specify the platform and
	#  the deployment target. You can optionally include the target after the platform.
	#

	# s.platform     = :ios
	# s.platform     = :ios, '5.0'

	#  When using multiple platforms
	s.ios.deployment_target = '7.0'
	s.osx.deployment_target = '10.9'


	# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  Specify the location from where the source should be retrieved.
	#  Supports git, hg, svn and HTTP.
	#

	s.source       = { :git => "https://github.com/zakdances/jCocoaPlus.git", :tag => "#{s.version}" }


	# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  CocoaPods is smart about how it includes source code. For source files
	#  giving a folder will include any h, m, mm, c & cpp files. For header
	#  files it will include any header in the folder.
	#  Not including the public_header_files will make all headers public.
	#

	s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
	# s.exclude_files = 'Classes/Exclude'

	# s.public_header_files = 'Classes/**/*.h'


	# ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  A list of resources included with the Pod. These are copied into the
	#  target bundle with a build phase script. Anything else will be cleaned.
	#  You can preserve files from being cleaned, please don't preserve
	#  non-essential files like tests, examples and documentation.
	#

	# s.resource  = "icon.png"
	# s.resources = "Resources/*.png"

	# s.preserve_paths = "FilesToSave", "MoreFilesToSave"


	# ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  Link your library with frameworks, or libraries. Libraries do not include
	#  the lib prefix of their name.
	#

	# s.framework  = 'Foundation'
	# s.frameworks = 'SomeFramework', 'AnotherFramework'

	# s.library   = 'iconv'
	# s.libraries = 'iconv', 'xml2'

	s.default_subspec = 'all'

	s.subspec 'all' do |a|
		a.dependency 'jCocoaPlus/NSRange'
	end

	s.subspec 'NSRange' do |r|
		r.source_files = 'Classes/jNSRangePlus.{h,m}'
		r.dependency 'CocoaPlus/NSRange'
	end
	# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  If your library depends on compiler flags you can set them in the xcconfig hash
	#  where they will only apply to your library. If you depend on other Podspecs
	#  you can include multiple dependencies to ensure it works.

	s.requires_arc = true

	# s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
	# s.dependency 'CocoaPlus/NSRange'
	s.dependency 'Jantle'

end
