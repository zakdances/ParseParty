'use strict'
angular.module('ParsePartyApp.services')
.factory('CodeMirrorWrapper', ($, $q, Counter, jsBridge) ->

	$ ->
		$.Color.fn.toJSON = () ->
			rgba = @rgba()
			r: rgba[0]
			g: rgba[1]
			b: rgba[2]
			a: rgba[3]
		return

	# TODO: REPLACE THIS FUCKING GARBAGE WITH A REAL REACTIVE IMPLIMENTATION!!! GODDAAAAAAAAAAMMIIIIIIITTTTTTTT
	class CSSignal
		constructor: (name) ->
			@ds = []
			@_subscribers = []
			@_name = name
			@_mainD = null

		_nextsForDeferred: (d) ->
			w = @_subscribers.filter (sub) => if sub.sFilter == 'next' and sub.d == d then true else false
			w

		_fireElses: (d) ->
			ns =  @_nextsForDeferred d
			if ns.length == 0
				d.promise.then e.callback for e in @_subscribers.filter (sub) => if sub.sFilter == 'else' then true else false
			return

		_addSubscriber: (callback, sFilter) ->
			try
				data = {}
				data.callback = callback
				data.sFilter = if sFilter then sFilter else throw 'ERROR: sFilter value ' + JSON.stringify(sFilter) + ' is not valid.'

				if sFilter == 'signal'
					@_d()
	

				else if sFilter == 'next'

					validDs = []
					for d in @ds when @_nextsForDeferred(d).length == 0
						validDs.push d
	

					d = if validDs.length > 0 then validDs[0] else @_d $q.defer()
	
					d.promise.then callback

					data.d = d

				@_subscribers.push data

			catch e
				jsBridge.then (jsBridge) =>
					jsBridge.send String(e)
					return
			@p()

		_d: (newD) ->
			try

				ds = @ds

				ds.push newD if newD
				ds.push $q.defer() if ds.length == 0
					
				d = ds[0]


				if not @_mainD or @_mainD isnt d
					@_mainD = d
					@_setupD d


			catch e
				jsBridge.then (jsBridge) =>
					jsBridge.send String(e)
					return

			newD ? d

		_setupD: (d) ->

			d.promise.then () =>
				@_fireElses d

				subscribedSignals = @_subscribers.filter (sub) => if sub.sFilter == 'signal' then true else false
				d.promise.then s.callback for s in subscribedSignals

				return

			d.promise.finally () =>
				# Remove "Next" subscribers
				for s in @_nextsForDeferred d
					s.d = null
					i = @_subscribers.indexOf s
					if i isnt -1
						@_subscribers.splice i, 1
				
				# Remove finished deferrdes
				
				i = @ds.indexOf d
				if i isnt -1
					@ds.splice i, 1

				return

			return

		p: () ->
			@_d().promise

		s: () -> @_newProxyPromise 'signal'

		# Only gets fired once, and uniquely (only "next" fired that once).
		next: () -> @_newProxyPromise 'next'

		else: () -> @_newProxyPromise 'else'
			# d = @_d $q.defer()
			# d.promise

		_newProxyPromise: (label) ->
			data = {}
			data.then = (callback) =>
				@_addSubscriber callback, label
				data
			data

		



	class CodeMirrorWrapperr
		constructor: (args={}) ->

			@CodeMirror = args.CodeMirror ? CodeMirror
			@_cm 				= null
			@doc 				= null
			@display 			= null
			@_selectedRanges 	= null
			@_changeObj 		= null

			@_proxyListeners 	= []
			@_listeners 		= []


			@signals = {}
			@signals.change			= new CSSignal('change')
			# @signals.change._name = 'change'
			@signals.cursorActivity = new CSSignal('cursorActivity')
			# @signals.change._name = 'cursorActivity'
	
			@cm args.cm if args.com


		cm: (cm) ->

			if cm and cm != @_cm
				@_cm = cm
				@doc = @_cm.doc
				@display = @_cm.display
				# @_selectedRanges = @selectedRanges()
				

				beforeSC 	= 'beforeSelectionChange'
				cA 		= 'cursorActivity'
				# bCha 	= 'beforeChange'
				cha 	= 'change'

				@on beforeSC, (cm, selection) =>

					@_selectedRanges = @selectedRanges()

					return

				@on cA, (cm) =>
						
					data = {}
					data.cm = @
					data.change = @_changeObj if @_changeObj

					selectedRanges = @selectedRanges()
					if @_selectedRanges and not @constructor.areSelectedRangesEqual( selectedRanges, @_selectedRanges )
						cAData = {}
						cAData.ranges = selectedRanges
						cAData.oldRanges = @_selectedRanges

						data.cursorActivity = cAData

					# data = {}
					@_selectedRanges = null
					@_changeObj = null

					@signals.cursorActivity._d().resolve data


					return

				@on cha, (cm, change) =>

					@_changeObj = change

					data = {}
					data.cm = @
					data.change = change

					@signals.change._d().resolve data

					return



				# for l in @_proxyListeners
				# 	@on l.event, l.callback

			@_cm

		# Native CodeMirror instance methods__

		getTokenAt: (position, precise={ precise: false }) ->
			@_cm.getTokenAt position, precise

		getMode: () ->
			@_cm.getMode()

		setOption: (option, val) ->
			@_cm.setOption option, val

		on: (event, callback) ->
			@_cm.on event, callback
			# Delegate to an extended listener, if on exists
			# proxyListener = @_proxyListeners.filter (l) => l.event == event
			# proxyListener = if proxyListener.length > 0 then proxyListener[0]

			# if proxyListener and proxyListener.callback != callback
			# 	# @_selectedRanges = @selectedRanges()

			# 	# dl = (l for l in @_listeners when l.event == cA and l.default == true)[0]
			# 	@_listeners.push
			# 		event: event
			# 		callback: callback

			# else
			# 	@_cm.on event, callback

			# return

		operation: (funct) ->
			@_cm.operation funct

		getRange: (range, seperator) ->
			@constructor.getRange @, range, seperator

		@getRange: (cm, range, seperator) ->
			start = cm.doc.posFromIndex range.location
			end = cm.doc.posFromIndex range.maxEdge()
			if seperator?
				return cm.doc.getRange start, end, seperator
			else
				return cm.doc.getRange start, end
			
			

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
			@constructor.parse @, range

		@parse: (cm, range) ->

			# jsBridge.send 'parsing range ' + JSON.stringify( range.range() ) + ' in mode: ' + JSON.stringify( cm1.getMode().name )

			

			# Create new attributed string to represent the chosen substring of CodeMirror's doc text.
			
			# Create an array in which to collect tokens
			tokens 				= []
			cssData 			= []


			# Loop through all of the substring's tokens, collecting tokens and CSS styles
			cm._parseLoop range, (pos, token) =>

				tsl 	= token.string.length
				tokenCSSData = @tokenCSSData token


				token.globalRange = new CSRange cm.doc.indexFromPos( line: pos.line, ch: token.start ), tsl

				
				# We don't want to overwrite any of the tokens default keys, so warn if neccesary.
				for key in ['classes', 'color'] when token[key]?
					jsBridge.then (jsBridge) =>
						jsBridge.send 'WARNING: Token key "' + JSON.stringify(key) + '" already exists, and will be overwritten. That should never happen. Fix your key names.'
						return
				
				if tokenCSSData
					token.classes = tokenCSSData.classes if tokenCSSData.classes?
					token.color =  tokenCSSData.properties.color if tokenCSSData.properties.color?
				
				

				cssData.push tokenCSSData if tokenCSSData? and Object.keys(tokenCSSData.properties).length > 0
				tokens.push token

				return


			totalGlobalRange = @globalRangeOfTokens tokens

			for t in tokens
				gr = t.globalRange
				t.localRange = new CSRange gr.location - totalGlobalRange.location, gr.length

			tokens


		_parseLoop: (range, callback) ->

			# c = new Counter
			# 	i: range.location + 1
			# 	end: if range.length > 0 then range.maxEdge() + 1 else range.maxEdge() + 2
			i = range.location + 1
			end = if range.length > 0 then range.maxEdge() + 1 else range.maxEdge() + 2

			while i < end

				pos 	= @doc.posFromIndex c.i
				token 	= @getTokenAt pos, precise: true
				tsl 	= token.string.length

				index = @doc.indexFromPos line: pos.line, ch: token.start 
				maxEdge = index + tsl

				callback pos, token

				i = if maxEdge + 1 > i then maxEdge + 1 else i + 1

			return

		@globalRangeOfTokens: (tokens) ->
			# Figure out where the string lies.
			t = [].concat tokens

			globalLocations 	= t.map (t) -> return t.globalRange.location
			globalMaxEdges 		= t.map (t) -> return t.globalRange.maxEdge()

			globalLocations.sort (a,b) -> a-b
			globalMaxEdges.sort (a,b) -> b-a

			start = globalLocations[0]
			end = globalMaxEdges[0]

			new CSRange start, end - start

		replaceCharacters: (args=string: null, range: null, event: null) ->
			args.cm = @
			@constructor.replaceCharacters args

		@replaceCharacters: (args=cm: null, string: null, range: null, event: null) ->
			cm = args.cm
			s 			= args.string
			r = args.range
			e = args.event

			startPos 	= cm.doc.posFromIndex r.location
			endPos		= cm.doc.posFromIndex r.maxEdge()

			# event 		= data.event

			jsBridge.then (jsBridge) ->
				if e == 'keypress'
					jsBridge.send 'keypress'
				return

			# myCallback = callback
	
			cm.doc.replaceRange s , startPos , endPos
	

		cursor: (context=null) ->
			@constructor.cursor @, context

		@cursor: (cm, context=null) ->
			pos = if context then cm.doc.getCursor(context) else cm.doc.getCursor()
			# context = args.context

			point = {}
			point.pos = pos
			point.line = pos.line
			point.ch = pos.ch
			point.location = cm.doc.indexFromPos pos
			point.index = point.location
			point

		selectedRanges: (selectedRanges) ->
			@constructor.selectedRanges @, selectedRanges

		@selectedRanges: (cm, selectedRanges) ->
	
			rs = if selectedRanges then [].concat(selectedRanges) else null

			if rs and rs.length > 0

				r = rs[0]

				start 		= cm.doc.posFromIndex r.location
				end 		= cm.doc.posFromIndex r.maxEdge()

				anchorPos 	= start
				headPos 	= anchorPos

				direction 	= if r.direction == 'up' or r.direction == 'down' then r.direction else throw 'ERROR: Invalid direction value ' + r.direction + '.'

				if r.length > 0

					anchorPos 	= if direction == 'down' then start 	else end
					headPos 	= if direction == 'up' 	then start 	else end

				# Make sure the range isn't already equal.
				cm.doc.setSelection anchorPos, headPos


			rs = []
			
			cursorHead = cm.cursor().index
			cursorAnchor = cm.cursor('anchor').index

			cursorStart = cm.cursor('start').index
			cursorEnd = cm.cursor('end').index

			affinity = if cursorAnchor < cursorHead then 'down' else 'up'


			r = new CSRange
				location: cursorStart
				length: cursorEnd - cursorStart
				attributes:
					affinity: affinity
			rs.push r

			rs

		@bodyCSSData: () ->
			el = $ 'body'

			tag: 'body' 
			properties:
				color: $.Color( el, 'color' ).toJSON()

		@tokenCSSData: (token) ->
			classNames = token.className

			data = {}
			data.classes = []
			data.properties = {}

			if classNames?
				data.classes.push 'cm-' + className for className in classNames.split(' ')

			# TODO: Should classless tokens get a "default" style?
			if data.classes.length > 0
				classes = data.classes.map (cssC) -> return '.' + cssC 
				el = $ classes.join ' '
				# color = $.Color( el, 'color' ).rgba()
				data.properties.color = $.Color( el, 'color' ).toJSON()

			data

		@areSelectedRangesEqual: (ranges1, ranges2) ->
			ranges1 = [].concat ranges1
			ranges2 = [].concat ranges2
			if ranges1.length != ranges2.length or ranges1.length == 0 then return false

			for idx in [0...ranges1.length]
				range1 = ranges1[idx]
				range2 = ranges2[idx]

				sameLocation = if range1.location == range2.location then true else false
				sameLength = if range1.length == range2.length then true else false
				sameDirection = if range1.direction == range2.direction then true else false

				if !sameLocation or !sameLength or !sameDirection
					return false


			true

	CodeMirrorWrapperr
)
