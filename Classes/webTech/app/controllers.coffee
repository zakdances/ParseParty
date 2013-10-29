'use strict'

parseRange = null

# Controllers 
angular.module('myApp.controllers', [
]).controller('MyCtrl1', ['$scope', 'jsBridge', 'CMi', 'CM', 'attributedContent', ($scope, jsBridge, CMi, CM, attributedContent) ->

	CMi.then (CMi) ->
		$('html, body, .ng-view').css
			'width': '100%'
			'height': '100%'
			'padding': '0'
			'margin': '0'
		# jsBridge = $scope.jsBridge
		jsBridge.send 'ready'

		doc = CMi.doc
		# jsBridge.then (jsBridge) ->
		# 	jsBridge.send 'asd'
		# 	jsBridge.send 'ready ' + String( typeof jsBridge )
		# 	return
		CMi.on 'change', (myCM, change) ->
			try
				data =
					docLength: myCM.doc.getValue().length
				# jsBridge.send 'got here1 ' + JSON.stringify( parseRange )
				if parseRange
					# jsBridge.send 'got here2'
					as = parse parseRange
					# jsBridge.send JSON.stringify( as )
					data['attributedString'] = as
				parseRange = null

				jsBridge.callHandler 'action',
					data,
					(data) ->
			catch e
				jsBridge.send String( e )
			
			
			return

		jsBridge.registerHandler 'tokenize', (data, callback) ->
			
			mode 		= if data.mode == 'scss' then 'text/x-scss' else data.mode
			string 		= data.string

			# Verify incoming data
			if !mode
				callback { errors: [ 'Error: no mode specified' ] }
				return

			jsBridge.send 'tokenizing in ' + mode + ' mode...'
			

			tokens = []
			try
				CM.runMode string, mode, (text, styleClass, state) ->
					# jsBridge.send 'state: ' + JSON.stringify( state )
					if text != ' ' and text != '' and text != '\n' and text != '\t'
						tokens.push { text: text, styleClass: styleClass, state: state }
					return
				# jsBridge.send 'ok'
				jsBridge.send tokens.length + ' tokens collected.'
			catch e
				jsBridge.send String( e )

			returnData = { 'tokens': tokens }
			callback returnData

			return


		jsBridge.registerHandler 'replaceCharacters', (data, callback) ->
			jsBridge.send 'replacing... ' + JSON.stringify( data )
			try
				mode 		= if data.mode == 'scss' then 'text/x-scss' else data.mode
				r 			= new NSRange( data.range.location, data.range.length )
				startPos 	= doc.posFromIndex r.location
				endPos		= doc.posFromIndex r.maxEdge()
				pr 			= data.parseRange
			catch e
				jsBridge.send String( e )
			

			if mode
				jsBridge.send 'setting mode to ' + mode
				CMi.setOption 'mode', mode
			if pr
				parseRange = new NSRange( pr.location, pr.length )
			doc.replaceRange data.string , startPos , endPos
			# if r.length > 0
			# 	doc.setValue doc.posFromIndex( r.location ), doc.posFromIndex( r.maxEdge() )
			# jsBridge.send data
			
			# jsBridge.send 'got here-1 ' + JSON.stringify( pr )
			
				# as = parse new NSAttributedRange( pr.location, pr.length )
			

			callback { 'message': true }
			return

		jsBridge.registerHandler 'parse', (data, callback) ->


			jsBridge.send 'doclength ' + docLength
			callback
				tokens			: tokens
				attributedRanges: attributedRanges
				stringLength	: docLength

			return

		parse = (range) ->

			as = new NSAttributedString( CMi.doc.getValue().substr range.location, range.length )
			jsBridge.send 'parsing in mode: ' + JSON.stringify( CMi.getMode().name )
			# doc 				= CMi.doc
			# docLength 			= doc.getValue().length

			# mode 				= if data.mode == 'scss' then 'text/x-scss' else data.mode
			# attributedString 	= data.attributedString
			# string 				= attributedString.string ? data.string

			# Verify incoming data
			# if !mode
			# 	responseCallback { errors: [ 'Error: no mode specified' ] }
			# 	return

			# CMi.setOption 'mode', mode
			# CMi.doc.setValue string

			tokens = []
			# attributedRanges = []

			# Function to loop through tokens
			# startIndex 	= doc.indexFromPos { line: 0, ch: 0 }
			# endIndex 	= startIndex
			# for i in [range.location...range.maxEdge()]

			i = if range.location > 0 then range.location else 1
			# Loop through tokens and collect all themed styles
			while i < range.maxEdge()
			

				try

					pos 	= doc.posFromIndex i
					token 	= CMi.getTokenAt pos

					start 	= doc.indexFromPos { line: pos.line, ch: token.start }
					end 	= start + ( token.end - token.start )
					

					# If token is valid, get style and format it as JSON
					if token.string.length > 0 and token.type != null and token.type != undefined
						jsBridge.send 'trying ' + JSON.stringify( token )

						r 			= new NSAttributedRange()
						r.location 	= start
						r.length 	= end - start

						cssEl = $('.cm-' + token.type)
						color = cssEl.css( 'color' ).replace(')','(').split('(')[1].split(',')

						$.extend true, r.attributes,
							color:
								r: color[0]
								g: color[1]
								b: color[2]

						as.attributedRanges.push r

						# jsBridge.send 'as created: ' + start + ' ' + end + ' ' + (end - start)
						jsBridge.send 'as created: ' + r.location + ' ' + r.length

					else
						nooooo = true
						# jsBridge.send 'uh oh...invalid token ' + token.string + ' ' + token.type  + ' ' + token.string.length

					tokens.push token
					

					
					# endIndex = r.maxEdge() + 1
					
				
				catch e
					jsBridge.send String( e )

				# Incriment the curent loop index to move to the next token
				
				# jsBridge.send 'before ' + i
				weird = end + 1
				# i = if weird - i > 0 then i + weird else i + 1
				# i = if end == i then i + 1 else end
				# i = if i == end + 1 then i + 1 else end + 1
				i = if weird > i then weird else i + 1
				# jsBridge.send 'after ' + i + ' ' + start + ' ' + end
				# i = 20
				# endIndex = 9999999999
				

				
				

				
				# jsBridge.send 'right2'


			# while endIndex < doc.getValue().length
			# 	jsBridge.send 'ok...'
			# 	newStart = doc.posFromIndex endIndex + 1
			# 	token = _myLoop newStart.line, newStart.ch
			# 	endIndex = doc.indexFromPos { line: newStart.line, ch: token.end }

		

			# token =
			# 	start: token.start
			# 	end: token.end
			# 	string: token.string
			# 	type: token.type
			# 	state: token.state
			
			as




		return

	return
# ]).controller('MyCtrl2', ['$scope', 'jsBridge', ($scope, jsBridge) ->
# 	jsBridge.send 'yup'
# 	# jsBridge.then (jsBridge) ->
# 	# 	jsBridge.send 'asdo'
# 	# 	jsBridge.send 'ready ' + String( typeof jsBridge )
# 	# 	return
# 	return
]).constant('routes',
	[
		controller: 'MyCtrl1'
		resolve:
			jsBridge: ['jsBridge', (jsBridge) ->
				jsBridge
			]
			# CM: ['CM', (CM) ->
			# 	CM
			# ]
	]
)

