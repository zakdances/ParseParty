'use strict'

angular.module('ParsePartyApp.services')

.factory 'cm1', (CodeMirrorWrapper, $q, jsBridge) ->
	class MyCM extends CodeMirrorWrapper
			constructor: () ->
				super CodeMirror: CodeMirror

				@_deferred = $q.defer()
				# Attach promise to access when CodeMirror instance is loaded in the DOM
				@ready = @_deferred.promise.then (cm) =>
					@cm cm
					@
		

			


	try
		instance = new MyCM()
	catch e
		jsBridge.then (jsBridge) ->
			jsBridge.send 'cm1 making error: ' + String( e )
			return

	instance
		
.factory 'cm1OpsQueue', ($q, CMOpsQueue, jsBridge) -> 
	new CMOpsQueue()

.factory 'CMOpsQueue', ($q, jsBridge) ->
	# try
		
	class CMOpsQueue_
		constructor: () ->

			@_lastOp = null
			# @_ops = []

		lastOp: (op) ->
			@_lastOp = op.p if op
			if @_lastOp then @_lastOp else $q.when()

		swapOut: (op) ->
			lastOp = @lastOp()
			@lastOp op
			lastOp

		# hook: () ->
		# 	ops = @_ops
		# 	l = ops.length
		# 	if l > 0 then ops[l - 1].done() else $q.when()

		# addOp: (op) ->
		# 	ops = [].concat op

		# 	for op in ops
		# 		@_ops.push op
		# 		@_addOp op


		# 	if ops.length == 1 then ops[0] else ops

		# _addOp: (op) ->
		# 	op.done().finally () =>
		# 		@removeOp op
		# 		return
		# 	return

		# removeOp: (op) ->
		# 	try
		# 		ops = [].concat op

		# 		removedOps = []

		# 		for op in ops
		# 			i = @_ops.indexOf op
		# 			if i isnt -1
		# 				@_ops.splice i, 1
		# 				removedOps.push op

				
		# 		ops = if removedOps.length > 0 then removedOps else ops
		# 		l = ops.length

		# 		string = if l == 1 then 'Op ' else 'Ops '
		# 		string = string + type for type in ops.map( (op) -> op.type() ).join ', '
		# 		string = if removedOps.length > 0 then string + ' removed succesfully.' else string + ' was not removed because they weren\'t in the queue.'
		# 		string = string + ' ' + @_ops.length + ' still left in the queue.' 

		# 	catch e
		# 		string = String e

		# 	jsBridge.then (jsBridge) ->
		# 		jsBridge.send string
		# 		return

		# 	if removedOps == 1 then removedOps[0] else if removedOps > 1 then removedOps else false

		# connectOps: (op1, how, op2) ->
		# 	try
		# 		d = $q.defer()
		# 		p = d.promise
		# 		op1.done().finally () ->
		# 			d.resolve()
		# 			return

		# 		deps = []
		# 		deps.push p for p in op2.deps
		# 		deps.push if how == 'then' then op1.done() else p 

		# 		$q.all( deps ).then (args) ->
		# 			try

		# 				jsBridge.then (jsBridge) ->
		# 					jsBridge.send 'Running ' + op2.type() + '...'
		# 					return
						
		# 				op2.run args

		# 			catch e
		# 				jsBridge.then (jsBridge) ->
		# 					jsBridge.send String e
		# 					return
		# 			arg
		# 		, (reason) ->
		# 			# jsBridge.then (jsBridge) ->
		# 			# 	jsBridge.send 'Rejecting ' + op2.type() + '...'
		# 			# 	return
		# 			op2._done.reject reason
		# 			return

		# 	catch e
		# 		jsBridge.then (jsBridge) ->
		# 			jsBridge.send String e
		# 			return
		# 	return


	CMOpsQueue_

.factory 'cm1Repo', ($q, jsBridge) ->

	class CM1Repo_ extends MGITRepository
		constructor: () ->
			super 100
		

	new CM1Repo_()
