'use strict'


myCallback 	= null
parseRange 	= null
deferred = null
# replaceData = null
# parseCallBack 	= null

# Controllers 
angular.module('myApp.controllers', [])
.controller('MyCtrl1', ['$scope', '$q', 'jsBridge', 'cm1', 'PPAttributedString', '_', 'Counter', ($scope, $q, jsBridge, cm1, PPAttributedString, _, Counter) ->

	cm1.promise.then () ->
		$('html, body, .ng-view').css
			'width': '100%'
			'height': '100%'
			'padding': '0'
			'margin': '0'
		# jsBridge = $scope.jsBridge
		

		# doc = cm1.doc
		display = cm1.display
		input = display.input
		# jsBridge.then (jsBridge) ->
		# 	jsBridge.send 'asd'
		# 	jsBridge.send 'ready ' + String( typeof jsBridge )
		# 	return
		cm1.on 'change', (cm, change) ->

			data 			= {}
			data.mode 		= cm.getMode().name
			data.docLength 	= cm.doc.getValue().length
			data.cursorData =
				location: cm1.doc.indexFromPos cm1.doc.getCursor()


			data.selectedRangesData =
				selectedRanges: selectedRanges()


			if parseRange then data.parseData = parse parseRange
			# try

			# 	# if parseRange
			# 		# data.parseData = parse parseRange

			# 		# attributedStrings: parseData.attributedStrings
			# 		# tokens: parseData.tokens
				
			# catch e
			# 	jsBridge.send String( e )

			jsBridge.callHandler 'action', data, (responseData) ->

			myCallback data if myCallback

			parseData = null
			myCallback = null

			return

		jsBridge.registerHandler 'request', (data, callback) ->
			requests = if data.request then [data.request] else data.requests

			data = {}
			data.requests = []

			for r in requests
				newData = {}
				newData.request = r.request

				switch r.request

					when 'tokenize'
						string = r.string
						mode = r.mode
						tokens = if string and mode then cm1.tokenize string, mode
						if tokens
							newData.tokens = tokens

					when 'parse'
						range = if r.range then CSRange.newRangeFromJSON r.range
						parseData = if range then cm1.parse range
						if parseData
							newData[k] = v for k, v of parseData

					when 'replace'
						s = r.string ? null
						range = if r.range then CSRange.newRangeFromJSON r.range
						e = r.event ? null

						if s and range

							deferred = $q.defer()
							deferred.promise.then (replaceData) ->
								newData[k] = v for k, v of replaceData
								return

							args = {}
							if s then args.string = s 
							if range then args.range = range
							if e then args.event = e
							cm1.replaceCharacters args

					when 'cursor'
						jsBridge.send 'This feature (cursor) is not yet implimented.'

					when 'selectedRanges'
						attributedRanges = if r.attributedRange then [r.attributedRange] else r.attributedRanges

						if attributedRanges
							if attributedRanges.length > 0
								ar = attributedRanges[0]
								ar = if ar.location and ar.length and ar.attributes and ar.attributes.affinity then new CSAttributedRange ar
							else
								ar = new CSAttributedRange cm1.cursor().location, 0

						# ars = if ar then cm1.selectionRanges(ar) else cm1.selectionRanges()
						newData.attributedRanges = if ar then cm1.selectedRanges(ar) else cm1.selectedRanges()

					when 'mode'
						m 	= if r.mode == 'scss' then 'text/x-scss' else r.mode
						currentMode = cm1.getMode().name

						# data = mode: currentMode
						if m != currentMode
							cm1.setOption 'mode', m

						newData.mode = cm1.getMode().name
						# data.modeHistory = [
						# 	currentMode
						# 	cm1.getMode().name
						# ]


				data.requests.push newData


			if deferred
				deferred.promise.then () ->
					callback newData
					return
			else
				callback newData

			deferred = null
			return

		jsBridge.registerHandler 'cursorAndSelectedRannges', (data, callback) ->
			
			cd = data.cursor
			cl = if cd? then cd.location

			sr = data.selectionRanges
			# sr = if srd? then srd.ranges
			# aff = if srd? then srd.affinity
			# jsBridge.send 'sr: ' + JSON.stringify( sr )

			try
				if cl? and typeof cl is 'number'
					
					cm1.doc.setCursor cm1.doc.posFromIndex cl
				
				if Array.isArray(sr) and sr.length > 0

					# r = CSRange.newRangeFromJSON _sr[0]
					ar 			= new CSAttributedRange sr[0]
					aff 		= ar.attributes.affinity
					start 		= cm1.doc.posFromIndex ar.location
					
					anchorPos 	= start
					headPos 	= anchorPos
					if ar.length > 0 and ( aff == 'up' or aff == 'down' )
						end = cm1.doc.posFromIndex ar.maxEdge()

						anchorPos 	= if aff == 'down' then start else end
						headPos 	= if aff == 'down' then end else start

					# cm1.doc.setCursor headPos
					cm1.doc.setSelection anchorPos, headPos

				# sr = selectedRanges()

				

			catch e
				jsBridge.send String( e )


			newData =
				cursor: cursorData()
				selectionRanges: selectionRangesData()

			callback newData

			return

		# cursorData = () ->
		# 	location: cm1.doc.indexFromPos cm1.doc.getCursor()

		selectionRangesDataa = () ->

			selectionRanges = []
			
			cursorHead = cm1.doc.indexFromPos cm1.doc.getCursor()
			cursorAnchor = cm1.doc.indexFromPos cm1.doc.getCursor 'anchor'

			if cursorAnchor != cursorHead
				start = cm1.doc.indexFromPos cm1.doc.getCursor 'start'
				end = cm1.doc.indexFromPos cm1.doc.getCursor 'end'

				ar = new CSAttributedRange
					location: start
					length: end
					attributes:
						affinity: if cursorAnchor < cursorHead then 'down' else 'up'
				selectionRanges.push ar
				# data.affinity = if cursorAnchor < cursorHead then 'down' else 'up'
			
			# _selectedRanges.push new CSRange cursorIndex, cm1.doc.getSelection().length
			selectionRanges

		jsBridge.registerHandler 'moode', (data, callback) ->
			# jsBridge.send 'setting mode...'
			try
				newMode 	= if data.mode == 'scss' then 'text/x-scss' else data.mode
				currentMode = cm1.getMode().name

				data = mode: currentMode
				if newMode and newMode != currentMode
					cm1.setOption 'mode', newMode
					data.modeHistory = [
						currentMode
						cm1.getMode().name
					]

				callback data
			catch e
				jsBridge.send String( e )
			return

		# jsBridge.registerHandler 'tokenize', (data, callback) ->
			
		# 	mode 		= if data.mode == 'scss' then 'text/x-scss' else data.mode
		# 	string 		= data.string

		# 	# Verify incoming data
		# 	if !mode
		# 		callback error: 'Error: no mode specified'
		# 		return

		# 	jsBridge.send 'tokenizing in ' + mode + ' mode...'
			

		# 	tokens = []
		# 	try
		# 		cm1.CodeMirror.runMode string, mode, (text, styleClass, state) ->
		# 			tokens.push
		# 				text: text
		# 				styleClass: styleClass
		# 				state: state
		# 			return

		# 	catch e
		# 		jsBridge.send String( e )

		# 	callback 'tokens': tokens

		# 	return


		# jsBridge.registerHandler 'replaceCharacterss', (data, callback) ->
		# 	jsBridge.send 'replacing ' + JSON.stringify( data.range ) + ' with ' + data.string.substr( 0, 5 )


		# 	try
			
		# 		s 			= data.string
		# 		r 			= CSRange.newRangeFromJSON data.range

		# 		startPos 	= doc.posFromIndex r.location
		# 		endPos		= doc.posFromIndex r.maxEdge()
		# 		if data.parseRange then parseRange = CSRange.newRangeFromJSON data.parseRange
		# 		event 		= data.event

		# 		if event == 'keypress'
		# 			jsBridge.send 'keypress'

		# 		# myCallback = callback

		# 		doc.replaceRange s , startPos , endPos

		# 	catch e
		# 		jsBridge.send String( e )
			

			

			# callback { 'message': true }
			return

		jsBridge.registerHandler 'parseee', (_data, callback) ->

			try
				r = CSRange.newRangeFromJSON _data.range

				data 			= {}
				data.mode 		= cm1.getMode().name
				data.docLength 	= cm1.doc.getValue().length
			catch e
				jsBridge.send String( e )

			

			
			

			data.parseData = parse r

			callback data

			return

		parsee = (range) ->
			try
				jsBridge.send 'parsing range ' + JSON.stringify( range.range() ) + ' in mode: ' + JSON.stringify( cm1.getMode().name )

				

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

					pos 	= cm1.doc.posFromIndex c.i
					token 	= cm1.getTokenAt pos, precise: true
					tsl 	= token.string.length

					ar = attributedRanges[ attributedRanges.push( new CSAttributedRange defaultContextName: 'global' ) - 1 ]
					ar.range cm1.doc.indexFromPos( line: pos.line, ch: token.start ), tsl
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



					jsBridge.send 'attributes created at global range: ' + ar.location + ' ' + ar.length

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
				jsBridge.send 'lr: ' + JSON.stringify( ar.range() ) + ' gr: ' + JSON.stringify( ar.c('global').range() )

				# ar.m 'globalRange', gr
				as = new PPAttributedString string: doc.getValue().substr( r.c('edited').location, r.c('edited').length )
				as.attributedRanges.push ar for ar in attributedRanges


				# jsBridge.send 'range: ' + JSON.stringify( r ) + 'string length: ' + as.string.length + ' string: ' + as.string
			catch e
				jsBridge.send String( e )

							
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



		jsBridge.send 'ready'

		# cursorCheckIteration = 0
		# setInterval () ->
		# 	if cursorCheckIteration < 1000
		# 		c = cm1.doc.getCursor()
		# 		c.index = cm1.doc.indexFromPos c
		# 		jsBridge.send JSON.stringify( c )

		# 	cursorCheckIteration++

		# 	return
		# , 1000

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

