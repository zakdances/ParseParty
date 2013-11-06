#### js2coffee version 0.1.3
#### ---- main/services.js
'use strict'

# Services 

# Demonstrate how to register services
# In this case it is a simple value service.
angular.module('myApp.services', [])
# .value( 'version', '0.1' )
.factory('myJQ', ['$q', ($q) ->
	deferred = $q.defer()
	$ ->
		deferred.resolve $
	deferred.promise
])
.factory('jsBridge', ['$q', ($q) ->

	deferred = $q.defer()

	onBridgeReady = (event) ->
		bridge 		= event.bridge
		bridge.init()
		deferred.resolve bridge

	document.addEventListener 'WebViewJavascriptBridgeReady', onBridgeReady, false

	deferred.promise
])
.factory('CMdi', ['$q', ($q) ->
	$q.defer() 
])
.factory('CMi', ['CMdi', (CMdi) ->
	CMdi.promise 
])
.factory('CM', [() ->
	CodeMirror
])
.factory('_', [() ->
	window._
])
.factory('newNormalizedRange', [() ->
	(varA, varB) ->
		if typeof varA == 'object'
			varA = varA.location
			varB = varA.length

		a = if varB != 0 then ( i + varA for i in [0...varB] ) else varB
		a
])
.factory('PPAttributedString', [() ->
	# CSAttributedString
	class PPAttributedString extends CSAttributedString
		constructor: (args={}) ->
			super args
			# args = args ? {}
			# args.attributedRanges = args.attributedRanges ? []
			

			ar = new CSAttributedRange 0, @string.length, @.defaultAttributes()
			@attributedRanges.unshift ar
			# _attributedRanges =
			# 	color: color
			# if args.attributedRanges
			# 	for



		# newDefaultAttributedRange: (args={}) ->
		# 	ar = new CSAttributedRange 0, @string.length, @.defaultAttributes()
		# 	@attributedRanges.unshift ar
		# 	return

		defaultAttributes: () ->
			color = $('body').css( 'color' ).replace(')','(').split('(')[1].split(',')
			color =
				r: color[0]
				g: color[1]
				b: color[2]

			color: color

	PPAttributedString
])
