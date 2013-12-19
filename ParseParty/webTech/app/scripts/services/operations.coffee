'use strict'
angular.module('ParsePartyApp.services')


.factory 'CMOperation', ($q, jsBridge) ->
	class CMOperation
		constructor: (@_cm, type='none') ->
			# try
			if not @_cm then throw 'ERROR: An operation must be initialized with a CodeMirror wrapper as the first and only argument. ' + JSON.stringify(@_cm) + ' is invalid.'

			# @_whatAmI = 'CMOperation'
			@type = () -> type
			# @_preData = {}
			# @_postData = null
			# @deps = []
			# @_runDependencies = []

			
			
			# @__postData = {}

			# postDataPromise = @_postData.promise.then (data) =>
			# 	@_postData[k] = v for k, v of data
			# 	data
			# @postData = () -> postDataPromise

			

			@_d = $q.defer()

			@p = @_d.promise.then (arg) =>
				# type = arg.type ? type
				jsBridge.then (jsBridge) =>
					jsBridge.send @type() + ' op starting...'
					return
				arg

			@p.then () ->
				return
			, (error) =>
				jsBridge.then (jsBridge) =>
					# jsBridge.send 'sending rejection notice...'
					jsBridge.send @type() + '\'s deferred rejected with error: ' + error
					# jsBridge.send 'Sent'
					return
				error

			@p.finally () =>
				jsBridge.then (jsBridge) =>
					# jsBridge.send 'Something ended. But what?'
					jsBridge.send @type() + ' op has completed.'
				return
				
		
		@errorPromise: (e, d=$q.defer()) ->
			jsBridge.then (jsBridge) ->
				jsBridge.send String e
				return
			d.reject String e
			d.promise
		# p: () -> @_p



		# status: () ->
		# 	@_status
		# _setData: (data) ->
		# 	data.type = @type()
		# 	# data.commit = @commit if @commit
		# 	data

		# toJSON: () ->
		# 	data = {}
		# 	data[k] = v for k, v of @_postData
		# 	data
	
	
		# run: () ->
		# 	@_done.resolve()
		# 	return

		# __run: (deps) ->
		# 	@_postData.resolve {}
		# 	return

		

	CMOperation

.factory 'CMRangeOp', (CMOperation, $q, jsBridge) ->
	class CMRangeOp extends CMOperation
		constructor: (cm) ->
			super cm

			@type = () -> 'range'

			# TODO: Some of these variables (such as 'p' and 'd') need a forced scope.
			@p = @p.then (range: r, string: s, event: e, type: type, commit: c) -> do (p = null, cs = null, oldString = null, data = {}) ->
				try
					r 		= if r and r.location? and r.length? then new CSRange(r) else throw 'ERROR: Requested range ' + JSON.stringify(r) + ' is invalid.'

					cs = cm.getRange r # Current string.

					if s? and s != cs
						
						d = $q.defer()
						p = d.promise
						cm.signals.change.next().then () ->
							d.resolve()
							return

						args = {}
						args.string = s 
						args.range = r
						args.event = e if e

						cm.operation () ->
							cm.replaceCharacters args
							return

						oldString = cs
						cs = cm.getRange new CSRange r.location, s.length

					else if s?
						jsBridge.then (jsBridge) ->
							jsBridge.send 'Doc content is the same. Ignoring.'
							return

					
					data.type = type
					data.commit = c
					data.string = cs
					data.oldString = oldString if oldString?

					# p = p ? $q.when()
					p = ( p ? $q.when() ).then () ->
						data
					# else @_postData.resolve data

				catch e
					return CMOperation.errorPromise e
				p

		

		# p: () -> @__d.promise

	CMRangeOp	
		
.factory 'CMParseRangeOp', (CMOperation, jsBridge) ->
	class CMParseRangeOp extends CMOperation
		constructor: (cm) ->
			super cm

			@type = () -> 'parse'

			@p = @p.then (range: r, type: type, commit: c) ->
				try
					r = if r then new CSRange r else throw 'ERROR: Range ' + JSON.stringify(r) + ' is invalid.'

					parseData = cm.parse r
					tokens = parseData.tokens
					range = cm.constructor.globalRangeOfTokens tokens

					data = {}
					data.type = type
					data.commit = c
					data.tokens = tokens

				catch e
					return CMOperation.errorPromise e
				data

		# run: () ->
			

		

		# range: (range) ->
		# 	if range then @_preData.range = range
		# 	@_preData.range

		

	CMParseRangeOp



.factory 'CMSelectedRangesOp', (CMOperation, $q, jsBridge) ->
	class CMSelectedRangesOp extends CMOperation
		constructor: (cm) ->
			super cm

			@type = () -> 'selectedRanges'

			@p = @p.then (ranges: rs, type: type, commit: c) ->
				try
					p = null

					# ranges 			= pd.ranges
					crs 	= cm.selectedRanges()

					if rs
						r = rs[0]
						if r and r.location? and r.length? and ( r.direction is 'up' or r.direction is 'down' )
							
							r = new CSRange r
							if not cm.constructor.areSelectedRangesEqual r, crs
								
								d = $q.defer()
								p = d.promise
								cm.signals.cursorActivity.next().then () ->
									d.resolve()
									return

								oldRanges 	= crs
								crs 		= cm.selectedRanges r
						else
							throw 'ERROR: Range ' + JSON.stringify(r) + ' is not a valid range.'

						# if rg and not @_cm.constructor.areSelectedRangesEqual rg, currentRanges

							
					p = do (data = {}) ->

						data.type = type
						data.commit = c
						data.ranges = [].concat crs
						data.oldRanges = [].concat oldRanges if oldRanges

						( p ? $q.when() ).then (arg) ->
							data
				catch e
					return CMOperation.errorPromise e
				p


		

	CMSelectedRangesOp

.factory 'CMModeOp', (CMOperation, jsBridge) ->
	class CMModeOp_ extends CMOperation
		constructor: (cm) ->
			super cm

			@type = () -> 'mode'

			@p = @p.then (mode: m, type: type) ->
				try
					if m == 'scss' then m = 'text/x-scss'

					currentMode = cm.getMode().name
					if m != currentMode
						cm.setOption 'mode', m
						fromMode = currentMode

						jsBridge.then (jsBridge) ->
							jsBridge.send 'mode changed to ' + cm.getMode().name
							return

					data = {}
					data.type = type
					data.mode = cm.getMode().name
					data.fromMode = fromMode if fromMode

					# @_done.resolve data

				catch e
					return CMOperation.errorPromise e
					# throw String e
				data

		

	CMModeOp_

.factory 'CMTokenizeOp', (CMOperation, jsBridge) ->
	class CMTokenizeOp extends CMOperation
		constructor: (cm) ->
			super cm
			
			@type = () -> 'tokenize'

			@p = @p.then (mode: m, string: s, type: type) ->
				try
					if not s? then throw 'ERROR: String ' + JSON.stringify(s) + ' is not valid.'
					if not m? then throw 'ERROR: Mode ' + JSON.stringify(m) + ' is not valid.'

					data = {}
					data.type = type
					data.tokens = cm.tokenize s, m
					# data = @_setData data

				catch e
					return CMOperation.errorPromise e
				data

		

	CMTokenizeOp

.factory 'CMDocLengthOp', (CMOperation, jsBridge) ->
	class CMDocLengthOp extends CMOperation
		constructor: (cm) ->
			super cm

			@type = () -> 'docLength'

			@p = @p.then (type: type) ->
				try
				
					data = {}
					data.type = type
					data.length = cm.doc.getValue().length
					# data = @_setData data

				catch e
					return CMOperation.errorPromise e
				data
		

	CMDocLengthOp



