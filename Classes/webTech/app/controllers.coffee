'use strict'

parseRange = null
myCallback = null
# parseCallBack 	= null

# Controllers 
angular.module('myApp.controllers', [])
.controller('MyCtrl1', ['$scope', 'jsBridge', 'CMi', 'CM', 'PPAttributedString', '_', ($scope, jsBridge, CMi, CM, PPAttributedString, _) ->

	CMi.then (CMi) ->
		$('html, body, .ng-view').css
			'width': '100%'
			'height': '100%'
			'padding': '0'
			'margin': '0'
		# jsBridge = $scope.jsBridge
		

		doc = CMi.doc
		display = CMi.display
		input = display.input
		# jsBridge.then (jsBridge) ->
		# 	jsBridge.send 'asd'
		# 	jsBridge.send 'ready ' + String( typeof jsBridge )
		# 	return
		CMi.on 'change', (myCM, change) ->

			data 			= {}
			data.mode 		= myCM.getMode().name
			data.docLength 	= myCM.doc.getValue().length

			try
				

				
				# jsBridge.send 'got here1 ' + JSON.stringify( parseRange )

				if parseRange
					data.parseData 			= parse parseRange
					data.parseData.mode 	= data.mode

					# attributedStrings: parseData.attributedStrings
					# tokens: parseData.tokens

				

				jsBridge.callHandler 'action', data, (responseData) ->
				myCallback data if myCallback

				parseRange = null
				myCallback = null
				
			catch e
				jsBridge.send String( e )
			
			
			return

		jsBridge.registerHandler 'mode', (data, callback) ->
			# jsBridge.send 'setting mode...'
			try
				newMode 	= if data.mode == 'scss' then 'text/x-scss' else data.mode
				currentMode = CMi.getMode().name

				data = mode: currentMode
				if newMode and newMode != currentMode
					CMi.setOption 'mode', newMode
					data.modeHistory = [
						currentMode
						CMi.getMode().name
					]

				callback data
			catch e
				jsBridge.send String( e )
			return

		jsBridge.registerHandler 'tokenize', (data, callback) ->
			
			mode 		= if data.mode == 'scss' then 'text/x-scss' else data.mode
			string 		= data.string

			# Verify incoming data
			if !mode
				callback error: 'Error: no mode specified'
				return

			jsBridge.send 'tokenizing in ' + mode + ' mode...'
			

			tokens = []
			try
				CM.runMode string, mode, (text, styleClass, state) ->
					# jsBridge.send 'state: ' + JSON.stringify( state )
					# if text != ' ' and text != '' and text != '\n' and text != '\t'
					tokens.push
						text: text
						styleClass: styleClass
						state: state

					return
				# jsBridge.send 'ok'
				# jsBridge.send tokens.length + ' tokens collected.'
			catch e
				jsBridge.send String( e )

			# returnData = { 'tokens': tokens }
			callback 'tokens': tokens

			return


		jsBridge.registerHandler 'replaceCharacters', (data, callback) ->
			jsBridge.send 'replacing ' + JSON.stringify( data.range ) + ' with ' + data.string.substr( 0, 5 )


			try
			
				s 			= data.string
				r 			= CSRange.newRangeFromJSON data.range
				jsBridge.send 'r: ' + JSON.stringify( r )
				startPos 	= doc.posFromIndex r.location
				endPos		= doc.posFromIndex r.maxEdge()
				pr 			= if data.parseRange then CSRange.newRangeFromJSON data.parseRange
				event 		= data.event
				# catch e
				# 	jsBridge.send String( e )
				if event == 'keypress'
					jsBridge.send 'keypress'
				
				# if mode
				# 	jsBridge.send 'setting mode to ' + mode
				# 	CMi.setOption 'mode', mode
				if pr
					parseRange = pr

				myCallback = callback
				# jsBridge.send 'replacing range with s'
				doc.replaceRange s , startPos , endPos

			catch e
				jsBridge.send String( e )
			

			

			# callback { 'message': true }
			return

		jsBridge.registerHandler 'parse', (_data, callback) ->

			try
				r = CSRange.newRangeFromJSON _data.range

				data 			= {}
				data.mode 		= CMi.getMode().name
				data.docLength 	= CMi.doc.getValue().length
			catch e
				jsBridge.send String( e )

			

			
			

			data.parseData = parse r

			callback data

			return

		parse = (range) ->
			try
				jsBridge.send 'parsing range ' + JSON.stringify( range.range() ) + ' in mode: ' + JSON.stringify( CMi.getMode().name )



						# Create new attributed string to represent the chosen substring of CodeMirror's doc text.
				as 		= new PPAttributedString string: doc.getValue().substr( range.location, range.length )
						# Create an array in which to collect tokens
				tokens 	= []
				attributedRanges = []

				# Set loop parameters. 1 is added because CodeMirror doesn't detect tokens at their beginning location.
				_i 		= range.location + 1
				_loopEnd = range.maxEdge() + 1

				class Counter
					constructor: (@i=_i,@end=_loopEnd) ->

					incrimentSafelyTo: (new_i) ->
						@i = if new_i? and new_i > @i then new_i else @i + 1
						return

				c = new Counter()

			catch e
				jsBridge.send String( e )

			# Loop through all of the substring's tokens, collecting tokens and CSS styles
			while c.i < c.end

				pos 	= doc.posFromIndex c.i
				token 	= CMi.getTokenAt pos, precise: true
				tsl 	= token.string.length

				# Global range of token
				gr 	= new CSRange doc.indexFromPos( line: pos.line, ch: token.start ), tsl

				try

					

					# if gr.maxEdge() <= range.location and gr.location != range.location
					# rangeArray = range.array()
					# grArray = gr.array()
					intersection = _.intersection range.array(), gr.array()
					if intersection.length != tsl and intersection.length > 0
						gr.array intersection
					else if not gr.length == 0 and not _.intersection( range.array(), new CSRange( gr.location, 1 ).array() ).length > 0
						# newIntersection = _.intersection range.array()
						jsBridge.send 'Invalid token!'
						c.incrimentSafelyTo gr.maxEdge() + 1
						continue
					# if intersection.length == 0

					# if not ( range.location <= gr.location < range.maxEdge() )
					# 	# intersection = _.intersection range.array(), gr.array()

					# 	if intersection.length == 0
							# test = JSON.stringify _.intersection( range.array(), gr.array() )
							# jsBridge.send 'invalid? ' + test
							


					jsBridge.send 'token string: ' + token.string
					# gr 	= new CSRange i, tsl
					# lRange	= gRange.copy()
					# if range.length() > 0 and lRange.length() > 0
					# 	lRange	= CSRange.newRangeFromArray _.intersection( range.array(), lRange.array() )
					# lRange.m 'globalRange', gRange

					
					# ar = as.attributedRanges[ as.attributedRanges.push( new CSAttributedRange( i - range.location, tsl ) ) - 1 ]
					ar = attributedRanges[ attributedRanges.push( new CSAttributedRange() ) - 1 ]
					# jsBridge.send 'flyin over you: ' + JSON.stringify( ar.range() )
					# ar.range gr.range()
					ar.range gr.location - range.location, gr.length

					jsBridge.send 'lr: ' + JSON.stringify( ar.range() ) + ' gr: ' + JSON.stringify( gr.range() )

					# if range.length > 0 and ar.length > 0
					# 	ar.array _.intersection( range.array(), ar.array() )
					ar.m 'globalRange', gr

					# jsBridge.send 'just checking ' + ar.array() + ' ' + JSON.stringify( ar.range() ) + ' ' + _.intersection( range.array(), gr.array() )

					a = ar.attributes

					# jsBridge.send 'ar: ' + ar.location + ' ' + ar.length


					a.token = token


					if tsl > 0 and a.token.type? and a.token.type != undefined
						# jsBridge.send 'token: ' + JSON.stringify( token )
						
						sel = []
						sel.push '.cm-' + spanClass for spanClass in token.className.split ' '
						a.cssSelector 	= sel[sel.length - 1]
						

						cssEl 			= $(a.cssSelector)
						if not cssEl?
							jsBridge.send 'There was a serious error trying to find selector "' + a.cssSelector + '".'
						else if cssEl.length == 0
							jsBridge.send 'No element could be found with the class "' + a.cssSelector + '". Trying ' + '"' + token.className + '" instead...'
							cssEl 			= $(token.className)
							if cssEl.length == 0
								jsBridge.send 'No element could be found with the class "' + token.className + '" either.'
						

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



					jsBridge.send 'attributes created at local range: ' + ar.location + ' ' + ar.length

					# else
					# 	nooooo = true
						# jsBridge.send 'uh oh...invalid token ' + token.string + ' ' + token.type  + ' ' + token.string.length

					tokens.push token
					

					
					# endIndex = r.maxEdge() + 1
					
					

				catch e
					jsBridge.send String( e )

				c.incrimentSafelyTo gr.maxEdge() + 1
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
			range: range



		jsBridge.send 'ready'
		return

	return

]).constant('routes',
	[
		controller: 'MyCtrl1'
		resolve:
			jsBridge: ['jsBridge', (jsBridge) ->
				jsBridge
			]
			myJQ: ['myJQ', (myJQ) ->
				myJQ
			]
			# CM: ['CM', (CM) ->
			# 	CM
			# ]
	]
)

