'use strict'

angular.module('ParsePartyApp.directives')
.directive 'codeMirror', (cm1, jsBridge) ->

	(scope, el, attrs) ->

		try

			d  = cm1._deferred
			myCM = cm1.CodeMirror
			el.css
				width: '100%'
				height: '100%'

			cm = myCM el[0],
				lineNumbers: true
				autofocus: true
				autoCloseBrackets: true
				# onKeyEvent: (cm, e) ->
				# 	$.event.fix e
				# 	return
			$('.CodeMirror').css
				'width': '100%'
				'height': '100%'

			d.resolve cm
			
		catch e
			jsBridge.then (jsBridge) ->
				jsBridge.send String(e)
				return

		# jsBridge.then (jsBridge) ->
		# 	jsBridge.send 'directive finished'
		# 	return

		return

