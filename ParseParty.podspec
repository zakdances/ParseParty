Pod::Spec.new do |s|


	s.name         = "ParseParty"
	s.version      = "0.0.1"
	s.summary      = "ParseParty is a code parser written in Objective-C for OSX. Powered by CodeMirror."

	s.description  = <<-DESC
									 A longer description of Objective-CSS in Markdown format.

									 * Think: Why did you write this? What is the focus? What does it do?
									 * CocoaPods will be using this to generate tags, and improve search results.
									 * Try to keep it short, snappy and to the point.
									 * Finally, don't worry about the indent, CocoaPods strips it!
									 DESC

	s.homepage     = "https://github.com/zakdances/ParseParty"
	s.license      = 'MIT'
	s.author       = 'Zak'

	s.platform = :osx, '10.9'
	s.osx.deployment_target = '10.9'

	s.source       = { :git => "https://github.com/zakdances/ParseParty.git", :tag => "#{s.version}" }
	# s.source_files = 'Classes', 'Classes/**/*.{h,m}'

	
	# s.exclude_files = 'test.js', '**/test.js', 'submodules/CodeMirror/test.js', 'submodules/CodeMirror/**/test.js'



	s.default_subspec = 'Parse'

	s.subspec 'Core' do |c|
		c.source_files 		= 	'Classes', 'Classes/**/*.{h,m}'
		c.resource_bundles 	= 	{
								'PPJQueryBundle' => ['Classes/webTech/bower_components/jquery/jquery.js'],
								'PPUnderscoreBundle' => ['Classes/webTech/bower_components/underscore/underscore.js'],
								'PPCodeMirrorBundle' => ['submodules/CodeMirror/*.{js,css}', 'submodules/CodeMirror/**/*.{js,css}'],
								'PPAngularJSBundle' => ['Classes/webTech/bower_components/angular-seed/app/lib/angular/*{angular.js,angular-route.js}'],
								'PPMainScriptBundle' => ['Classes/webTech/app/.jsc/*{app.js,controllers.js,directives.js,filters.js,services.js}']
								}

		c.exclude_files = 'test.js', '**/test.js', 'submodules/CodeMirror/test.js', 'submodules/CodeMirror/**/test.js'
	end

	# s.subspec 'Tokenize' do |t|
	# 	# t.source_files = 'Classes', 'Classes/**/*.{h,m}'
		
	# end

	s.subspec 'Parse' do |p|

		p.resource_bundles = { 'PPScriptBundle' => ['Classes/webTech/app/.jsc/parse.js', 'Classes/webTech/bower_components/NSAttributedRange/NSAttributedRange.js', 'Classes/webTech/bower_components/NSAttributedString/NSAttributedString.js'] }
		# p.resource_bundles = { 'PPParseBundle' => ['Classes/webTech/app/.jsc/*{parse.js}', '../NSAttributedRange/.jsc/NSAttributedRange.js'] }

		p.exclude_files 	= 'test.js', '**/test.js', 'submodules/CodeMirror/test.js', 'submodules/CodeMirror/**/test.js'
# 		p.prefix_header_contents = '
# #import "PPParseProtocol.h"
# #import "ParseParty+Parse.h"
# #import "PPCodeMirror+Parse.h"
# '
# 		p.prefix_header_contents = '

# #import "ParseParty+Parse.h"

# '
		# p.prepare_command = <<-CMD
		# 					sed -i '1i whatever' *
		# 				CMD
		# p.prefix_header_contents = '#import ParseParty+Parse.h'
		# p.prefix_header_contents = '#import PPCodeMirror+Parse.h'
		p.dependency 'ParseParty/Core'

	end

	# s.subspec 'AutoParse' do |ap|
	# 	ap.resource_bundles = { 'MGitCoffeeScriptBungle' => ['Classes/webTech/bower_components/MGit-CoffeeScript/.built/MGit.js'] }

	# 	ap.exclude_files = 'test.js', '**/test.js', 'submodules/CodeMirror/test.js', 'submodules/CodeMirror/**/test.js'
	# 	ap.prefix_header_contents = '
	# 	#import "PPAutoParseProtocol.h"
	# 	#import "ParseParty+AutoParse.h"
	# 	#import "PPCodeMirror+AutoParse.h"
	# 	'

	# 	ap.dependency 'ParseParty/Parse'
	# 	ap.dependency 'MGit'
	# end


		
	# 	a.exclude_files 	= 'test.js', '**/test.js', 'submodules/CodeMirror/test.js', 'submodules/CodeMirror/**/test.js'

	# 	a.default_subspec = 'Syncing'

		
		




	# end

	

	s.framework  = 'Foundation'

	s.requires_arc = true

	s.dependency 'WebViewJavascriptBridge'
	s.dependency 'StandardPaths'
	s.dependency 'CocoaPlus/WebView'
	s.dependency 'jNSAttributedRange'
	# s.dependency 'promise'

end
