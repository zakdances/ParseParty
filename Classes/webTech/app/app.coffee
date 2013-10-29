'use strict'


# Declare app level module which depends on filters, and services
angular.module('myApp', [
	'ngRoute'
	# 'CodeMirror'
	'myApp.filters'
	'myApp.services'
	'myApp.directives'
	'myApp.controllers'
]).config [ '$routeProvider', 'routes', ($routeProvider, routes) ->

		$routeProvider.when '/',
			template: '<div code-mirror="5" style="width: 100%; height: 100%;"></div>'
			controller: 'MyCtrl1'
			# resolve: (r.resolve for r in routes when r.controller == 'MyCtrl1')[0]
			resolve:
				jsBridge: ['jsBridge', (jsBridge) ->
					jsBridge
				]
				# TODO: Why doesn't this work?
				# CM: ['CM', (CM) ->
				# 	CM
				# ]

		return
]

# angular.module('CodeMirror', [

# ])
# .value('val', CodeMirror)
# .directive('codeMirror', ['val', (cmi) ->
# 	return (scope, elm, attrs) ->

# 		# $('body').css 'background-color', 'orange'
# 		elm.css
# 			'width': '100%'
# 			'height': '100%'

# 		# console.log 'directive CodeMirror ran'
# 		# console.log String( elm )
# 		try
# 			cmi elm[0],
# 				lineNumbers: true
# 				autofocus: true
# 				autoCloseBrackets: true
# 				# onKeyEvent: (cm, e) ->
# 				# 	$.event.fix e
# 				# 	return
			
# 		catch e
# 			console.log 'error CM ' + String( e )
# 			# bridge.send 'error loading CodeMirror: ' + String( e )
		
# 		$('.CodeMirror').css
# 			'width': '100%'
# 			'height': '100%'
# 			# 'display': 'none'

# 		return
# ])

