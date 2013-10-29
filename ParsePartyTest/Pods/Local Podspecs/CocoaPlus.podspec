Pod::Spec.new do |s|


	s.name         = "CocoaPlus"
	s.version      = "0.0.7"
	s.summary      = "A take-only-what-you-need collection of helpful classes and categories for iOS and OSX."

	s.description  = <<-DESC
									 A longer description of CocoaPlus in Markdown format.

									 These are some simple, misceleneous class and categories for iOS and OSX. They use subspecs, so you can pick and choose want you want instead of needing the whole thing.
									 DESC

	s.homepage     = "https://github.com/zakdances/CocoaPlus"


	s.license      = 'MIT'

	s.author       = 'Zak'

	s.ios.deployment_target = '7.0'
	s.osx.deployment_target = '10.8'


	s.source       = { :git => "https://github.com/zakdances/CocoaPlus.git", :tag => "#{s.version}" }

	s.default_subspec = 'Core'



	s.subspec 'Core' do |cs|
		cs.ios.source_files  = 'iOS Classes', 'iOS Classes/**/*.{h,m}', 'iOS Categories', 'iOS Categories/**/*.{h,m}'
		cs.osx.source_files  = 'OSX Classes', 'OSX Classes/**/*.{h,m}', 'OSX Categories', 'OSX Categories/**/*.{h,m}'
		cs.exclude_files = '*RAC.{h,m}'
	end

	s.subspec 'WebView' do |wv|

		wv.default_subspec = 'All'

		wv.subspec 'All' do |a|
			a.osx.dependency 'CocoaPlus/WebView/Cl'
			a.osx.dependency 'CocoaPlus/WebView/Ca'
		end

		wv.subspec 'Cl' do |cl|
			# Nothing here
		end

		wv.subspec 'Ca' do |ca|
			ca.osx.source_files  = 'OSX Categories/WebView+Plus.{h,m}'
		end
		# cs.exclude_files = '*RAC.{h,m}'
		# cs.ios.source_files  = 'iOS Categories/UIWebView+Plus.{h,m}'
		
	end

	s.subspec 'CorePlusRac' do |cr|
		cr.ios.source_files  = 'iOS Classes', 'iOS Classes/**/*.{h,m}', 'iOS Categories', 'iOS Categories/**/*.{h,m}'
		cr.osx.source_files  = 'OSX Classes', 'OSX Classes/**/*.{h,m}', 'OSX Categories', 'OSX Categories/**/*.{h,m}'
		cr.dependency 'ReactiveCocoa'
	end

	# s.ios.frameworks   = ['CoreMedia', 'MediaPlayer', 'AVFoundation', 'QuartzCore', 'CoreGraphics']
	s.ios.frameworks   = ['UIKit']
	s.osx.frameworks   = ['Foundation', 'WebKit']

	s.requires_arc = true


end
