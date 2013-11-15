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
# .factory('CMdi', ['$q', ($q) ->
# 	$q.defer()
# ])
# .factory('cm', ['CMdi', (CMdi) ->
# 	CMdi.promise 
# ])
# .factory('CM', [() ->
# 	CodeMirror
# ])
.factory('cm1', ['CM', (CM) ->
	cm1 = new CM()

	cm1
])
.factory('CM', ['$q', 'PPAttributedString', '_', 'Counter', 'jsBridge', ($q, PPAttributedString, _, Counter, jsBridge) ->
	class CM
		constructor: (args={}) ->
			@CodeMirror = CodeMirror

			cm = args.cm ? null
			setCodeMirrorInstance cm

			if !@cm
				@deferred = args.deferred ? $q.defer()
				@promise = args.promise ? @deferred.promise

				@promise.then (cm) ->
					setCodeMirrorInstance cm
			# @instanceDeferred = args.deferred ? $q.defer()
			# @instancePromise = @deferred.promise

		setCodeMirrorInstance: (cm) ->
			@cm = cm
			@doc = if @cm then @cm.doc else null
			@display = if @cm then @cm.display else null

		# Native CodeMirror instance methods

		getTokenAt: (position, precise={ precise: false }) ->
			@cm.getTokenAt position, precise

		getMode: () ->
			@cm.getMode()

		setOption: (option, val) ->
			@cm.setOption option, val

		on: (event, callback) ->
			@cm.on event, callback

		# ___________________________________

		tokenize: (string, mode) ->

			# jsBridge.send 'tokenizing in ' + mode + ' mode...'
			
			tokens = []

			@CodeMirror.runMode string, mode, (text, styleClass, state) ->
				tokens.push
					text		: text
					styleClass	: styleClass
					state		: state
				return

			tokens

		parse: (range) ->
			@constructor.parse range, @

		@parse: (range, cm) ->

			# jsBridge.send 'parsing range ' + JSON.stringify( range.range() ) + ' in mode: ' + JSON.stringify( cm1.getMode().name )

			

					# Create new attributed string to represent the chosen substring of CodeMirror's doc text.
			
					# Create an array in which to collect tokens
			tokens 	= []
			attributedRanges = []

			# Set loop parameters. 1 is added because CodeMirror doesn't detect tokens at their beginning location.
			c = new Counter
				i: range.location + 1
				end: range.maxEdge() + 1


			# Loop through all of the substring's tokens, collecting tokens and CSS styles
			while c.i < c.end

				pos 	= cm.doc.posFromIndex c.i
				token 	= cm.getTokenAt pos, precise: true
				tsl 	= token.string.length

				ar = attributedRanges[ attributedRanges.push( new CSAttributedRange defaultContextName: 'global' ) - 1 ]
				ar.range cm.doc.indexFromPos( line: pos.line, ch: token.start ), tsl
				# Global range of token

				
				# intersection = _.intersection range.array(), gr.array()
				# if intersection.length != tsl and intersection.length > 0
				# 	gr.array intersection
				# else if not gr.length == 0 and not _.intersection( range.array(), new CSRange( gr.location, 1 ).array() ).length > 0

				# 	jsBridge.send 'Invalid token!'
				# 	c.incrimentSafelyTo gr.maxEdge() + 1
				# 	continue

				jsBridge.send 'token string: ' + token.string


				# jsBridge.send 'just checking ' + ar.array() + ' ' + JSON.stringify( ar.range() ) + ' ' + _.intersection( range.array(), gr.array() )

				a = ar.attributes

				# jsBridge.send 'ar: ' + ar.location + ' ' + ar.length


				a.token = token


				if tsl > 0 and a.token.type? and a.token.type != undefined
					
					sel = []
					sel.push '.cm-' + spanClass for spanClass in token.className.split ' '
					a.cssSelector 	= sel[sel.length - 1]
					

					cssEl 			= $(a.cssSelector)
					jsBridge.then (jsBridge) ->
						if not cssEl?
							jsBridge.send 'There was a serious error trying to find selector "' + a.cssSelector + '".'
						else if cssEl.length == 0
							jsBridge.send 'No element could be found with the class "' + a.cssSelector + '". Trying ' + '"' + token.className + '" instead...'
							cssEl 			= $(token.className)
							if cssEl.length == 0
								jsBridge.send 'No element could be found with the class "' + token.className + '" either.'
						return
					

					# TODO: Find a safer way to do this (only remove outer paranthesis)
					a.color = cssEl.css( 'color' ).replace(')','(').split('(')[1].split(',')
					a.color =
						r: a.color[0]
						g: a.color[1]
						b: a.color[2]
				else
					a.color = $('body').css( 'color' ).replace(')','(').split('(')[1].split(',')
					a.color =
						r: a.color[0]
						g: a.color[1]
						b: a.color[2]



				# jsBridge.send 'attributes created at global range: ' + ar.location + ' ' + ar.length

				# else
				# 	nooooo = true
					# jsBridge.send 'uh oh...invalid token ' + token.string + ' ' + token.type  + ' ' + token.string.length

				tokens.push token
				

				
				# endIndex = r.maxEdge() + 1
				
				
				c.incrimentSafelyTo ar.maxEdge() + 1




			
			# ar.range gr.location - range.location, gr.length
			
			globalRanges = ( { location: ar.location, length: ar.length, maxEdge: ar.maxEdge() } for ar in attributedRanges )

			start = _.sortBy( globalRanges, (r) ->
				r.location	
				)[0].location

			end = _.sortBy( globalRanges, (r) ->
				r.maxEdge	
				).pop().maxEdge

			r = new CSRange
				contexts:
					edited:
						location: start
						length: end - start
						default: true
					original: CSRange.newRangeFromRange range

			# originalR = r.c('original')

			
			for ar in attributedRanges
				ar.c 'local', ar.location - r.location, ar.length
				ar.switchDefaultContext 'local'

			
			
				
			# jsBridge.send 'global: ' + JSON.stringify( ar.c('global') )
			# jsBridge.send 'lr: ' + JSON.stringify( ar.range() ) + ' gr: ' + JSON.stringify( ar.c('global').range() )

			# ar.m 'globalRange', gr
			as = new PPAttributedString string: cm.doc.getValue().substr( r.c('edited').location, r.c('edited').length )
			as.attributedRanges.push ar for ar in attributedRanges


			# jsBridge.send 'range: ' + JSON.stringify( r ) + 'string length: ' + as.string.length + ' string: ' + as.string


							
			# Incriment the curent loop index to move to the next token
			
			# jsBridge.send 'before ' + i
			
			# i = if weird - i > 0 then i + weird else i + 1
			# i = if end == i then i + 1 else end
			# i = if i == end + 1 then i + 1 else end + 1
			
			# _i 	= gr.maxEdge() + 1
			# i 	= if _i > i then _i else i + 1
			# jsBridge.send 'after ' + i + ' ' + start + ' ' + end
			# i = 20
			# endIndex = 9999999999
				
			
			
			attributedString: as
			tokens: tokens
			range: r

		replaceCharacters: (args=string: null, range: null, event: null) ->
			args.cm = args.cm ? @
			@constructor.replace args

		@replaceCharacters: (args=cm: null, string: null, range: null, event: null) ->
			cm = args.cm
			s 			= args.string
			# r 			= CSRange.newRangeFromJSON data.range
			r = args.range
			e = args.event

			startPos 	= cm.doc.posFromIndex r.location
			endPos		= cm.doc.posFromIndex r.maxEdge()
			# parseRange = CSRange.newRangeFromJSON data.parseRange
			# event 		= data.event

			jsBridge.then (jsBridge) ->
				if e == 'keypress'
					jsBridge.send 'keypress'
				return

			# myCallback = callback

			cm.doc.replaceRange s , startPos , endPos

		cursor: (context=null) ->
			# args = if typeof args == 'string' then context: args else args
			# args.cm = args.cm ? @
			@constructor.cursor @, context

		@cursor: (cm, context=null) ->
			cm = args.cm
			context = args.context

			point = {}
			point.position = if context then cm.doc.getCursor(context) else cm.doc.getCursor()
			point.location = cm.doc.indexFromPos point.position
			point

		selectedRanges: (attributedRanges) ->
			@constructor.selectedRanges @, attributedRanges

		@selectedRanges: (cm, attributedRanges) ->
			# cm = args.cm
			ars = attributedRanges

			if ars
				isArray = Array.isArray ars
				if !isArray and typeof ars == 'object'
					ars = [ars]
				else if !isArray
					return null

				ar = ars[0]
				affinity = ar.attributes.affinity

				start 		= cm.doc.posFromIndex ar.location	
				anchorPos 	= start
				headPos 	= anchorPos

				if ar.length > 0 and ( affinity == 'up' or affinity == 'down' )
					end = cm1.doc.posFromIndex ar.maxEdge()

					anchorPos 	= if affinity == 'down' then start 	else end
					headPos 	= if affinity == 'down' then end 	else start

				# cm1.doc.setCursor headPos
				cm1.doc.setSelection anchorPos, headPos


			ars = []
			
			cursorHead = cm.cursor().location
			cursorAnchor = cm.cursor('anchor').location

			if cursorAnchor != cursorHead
				start = cm.cursor('start').location
				end = cm.cursor('end').location

				ar = new CSAttributedRange
					location: start
					length: end
					attributes:
						affinity: if cursorAnchor < cursorHead then 'down' else 'up'
				ars.push ar
				# data.affinity = if cursorAnchor < cursorHead then 'down' else 'up'
			
			# _selectedRanges.push new CSRange cursorIndex, cm1.doc.getSelection().length
			ars



	CM
])
.factory('_', [() ->
	window._
])
.factory('Counter', [() ->
	class Counter
		constructor: (args={}) ->
			@i = args.i ? NaN
			@end = args.end ? NaN

		incrimentSafelyTo: (new_i) ->
			@i = if new_i? and new_i > @i then new_i else @i + 1
			return

	Counter
])
# .factory('newNormalizedRange', [() ->
# 	(varA, varB) ->
# 		if typeof varA == 'object'
# 			varA = varA.location
# 			varB = varA.length

# 		a = if varB != 0 then ( i + varA for i in [0...varB] ) else varB
# 		a
# ])
.factory('PPAttributedString', [() ->
	# CSAttributedString
	class PPAttributedString extends CSAttributedString
		constructor: (args={}) ->
			super args
			

			# ar = new CSAttributedRange 0, @string.length, @.defaultAttributes()
			@attributedRanges.unshift new CSAttributedRange 0, @string.length, @.defaultAttributes()


		defaultAttributes: () ->
			color = $('body').css( 'color' ).replace(')','(').split('(')[1].split(',')
			color =
				r: color[0]
				g: color[1]
				b: color[2]

			color: color

	PPAttributedString
])
