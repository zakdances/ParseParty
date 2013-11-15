'use strict'

# Directives 
angular.module('myApp.directives', [])
.directive( 'appVersion', [
	'version'
	(version) ->
		(scope, elm, attrs) ->
			elm.text version
			return
])
.directive('codeMirror', ['cm1', 'jsBridge', (cm1, jsBridge) ->
	# console.log 'directive'
	

	(scope, el, attrs) ->
		# CM = CMd.CodeMirror
		d  = cm1.deferred
		
		# $('body').css 'background-color', 'orange'
		el.css
			'width': '100%'
			'height': '100%'

		# console.log 'directive CodeMirror ran'
		# console.log String( elm )
		try
			cm = CM el[0],
				lineNumbers: true
				autofocus: true
				autoCloseBrackets: true
				# onKeyEvent: (cm, e) ->
				# 	$.event.fix e
				# 	return
			$('.CodeMirror').css
				'width': '100%'
				'height': '100%'
			
		catch e
			console.log String( e )
			# bridge.send 'error loading CodeMirror: ' + String( e )
		
		
			# 'display': 'none'
		d.resolve cm
		# jsBridge.then (jsBridge) ->
		# 	jsBridge.send 'jsBridge ' + String( d.promise )
		# 	return
		# scope.apply()
		return
])