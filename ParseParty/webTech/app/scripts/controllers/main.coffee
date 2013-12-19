'use strict'

# myCallback 	= null
# parseRange 	= null
# deferred = null
# replaceData = null rqOps.reduce ( rqOps, type: type, commit: id: cid, idx, arr) ->
# parseCallBack 	= null

# Controllers 
angular.module('ParsePartyApp.controllers')
# .controller 'MyCtrl1', ($scope, $, $q, jsBridge, cm1, CMOperation, CMRangeOp, CMSelectedRangesOp, CMTokenizeOP, CMParseRangeOp, CMDocLengthOp, CMModeOp, CMOpsRepo) ->
.controller 'MyCtrl1', ($, $q, jsBridge, cm1, CMOperation, CMModeOp, CMRangeOp, CMSelectedRangesOp, CMDocLengthOp, cm1OpsQueue, cm1Repo) ->
	cm1.ready.then () ->



		jsBridge.registerHandler 'request', (data, callback) -> do (rqOpsj = []) ->

			if not data.request and not data.requests
				throw do (error = 'ERROR: No requests specified.') ->
					callback error
					error

			rqOpsj = rqOpsj.concat data.request if data.request
			rqOpsj = rqOpsj.concat data.requests if data.requests


			jsBridge.send 'registerHandler requests(' + rqOpsj.length + '): ' + JSON.stringify(rqOpsj)
			# rqOps = rqOps.map (opj) ->
			# 	opj.commit = {}
			# 	opj.commit.id = 777
			# 	opj

			jsBridge.send 'Beginning the loop...'
			try
				do (rqOps = []) -> rqOpsj.every (opj, idx, arr) -> do ( type = opj.type,
																		cid = null,
																		prevOp=arr[idx - 1],
																		nextOp=arr[idx + 1],
																		prevOpCID=null,
																		nextOpCID=null,
																		op=null, checkRepoOp=null,
																		commitToRepoOp=null,
																		callbackOp=null,
																		c = new MGITCommit() ) ->
					try
						# do ( opj=arr[idx], prevOp=arr[idx - 1], nextOp=arr[idx + 1], prevOpCID=null, nextOpCID=null, op=null, checkRepoOp=null, commitToRepoOp=null, callbackOp=null, commit=null ) ->

						jsBridge.send 'Found request for ' + type + '. Processing...'

						# p.prevOp = arr[idx - 1]
						prevOpCID = if prevOp and prevOp.commit then prevOp.commit.id else null
						# p.nextOp = arr[idx + 1]
						nextOpCID = if nextOp and nextOp.commit then nextOp.commit.id else null

						c.source = 'ParseParty'

						switch type

							when 'tokenize'
								op = new CMTokenizeOP cm1

							when 'parse'
								op 			 = new CMParseRangeOp cm1
								opj.commit or= c

							when 'range'
								op 			 = new CMRangeOp cm1
								opj.commit or= c if opj.string?

							when 'cursor'
								throw 'This feature (cursor) is not yet implimented. It might not ever be. Use selectedRanges instead.'

							when 'selectedRanges'
								op 			 = new CMSelectedRangesOp cm1
								opj.commit or= c if opj.range or opj.ranges

							when 'mode'
								op = new CMModeOp cm1

							when 'docLength'
								op = new CMDocLengthOp cm1

						if op
							rqOps.push op

							cid = if opj.commit then opj.commit.id else null

							if cid?
								if cid isnt prevOpCID
									checkRepoOp = new CMOperation cm1, 'checkRepo'
									checkRepoOp.p = checkRepoOp.p.then (cid) ->
										try
											jsBridge.send '*** Checking for duplicate commits with ID: ' + cid + '...***'
											if cm1Repo.getChangeOrCommit(cid) then throw '*** Change is already commited to the repo! Abandoning. ***'
											jsBridge.send '*** No duplicate changes/commits found in the repo. ***'
										catch e
											return CMOperation.errorPromise e
										true


									do (cro = checkRepoOp, cid) -> cm1OpsQueue.swapOut(cro).finally () ->
										cro._d.resolve cid
										return

								# do ( a=p.swapOut(p.op), b=p.op, c=_arg1 ) ->
								do (op, opj) -> cm1OpsQueue.swapOut(op).then () ->
										op._d.resolve opj
										return
									, (e) ->
										jsBridge.send 'Op rejected correctly'
										op._d.reject e
										e

							else
								do (op, opj) -> cm1OpsQueue.swapOut(op).finally () ->
									op._d.resolve opj
									return


							if cid? and cid isnt nextOpCID
								commitToRepoOp = new CMOperation cm1, 'commitToRepo'
								commitToRepoOp.p = commitToRepoOp.p.then (commit : id : cid) ->
									try
										# c = deps[0].commit
										jsBridge.send 'Pushing commit with ID: ' + cid
										return cm1Repo.addAndCommit new MGITCommit cid
										# @_d.resolve c 

									catch e
										return CMOperation.errorPromise e

									# c

								do (ctro=commitToRepoOp, opj) -> cm1OpsQueue.swapOut(ctro).then () ->
										jsBridge.send 'commitToRepoOp resolved. All systems go.'
										ctro._d.resolve opj
										return
									, (e) ->
										jsBridge.send 'commitToRepoOp rejected correctly'
										ctro._d.reject e
										e
								# TODO: Needs destructuring
								# commitChain = arr.filter (commit : id : _cid) -> _cid and _cid is cid
								# commitChain.shift()
								# commitChain.pop()
								# jsBridge.send 'commit chain: ' + JSON.stringify( commitChain.map (op) -> op.type() )
								# commitOp.deps.push op.done() for op in commitChain
							if idx is arr.length - 1
								callbackOp = new CMOperation cm1
								callbackOp.type = () -> 'callbackOp'

								callbackOp.p = do ( rqOps, d=$q.defer() ) ->
									callbackOp.p.then () ->
										try
											rqOps = rqOps.map (op, idx, arr) ->
												do (d = {}) ->
													op.p.then (data) ->
														d[k] = v for k,v of data
														d
													, (error) ->
														d.type or= op.type()
														d.error = error 
														return
													.finally () ->
														return
													.then () ->
														d

											do (data = {}) -> $q.all( rqOps ).then (da) ->
												# data = {}
												data.requests = da

												logRequestsDEBUG 'registerHandler response: ', data
												d.resolve callback data
												# @_d.resolve data
												return
										catch e
											return CMOperation.errorPromise e

										d.promise

									, (e) ->
										data = {}
										data.e = e
										data.requests = rqOps.map (op) -> type: op.type, error: e

										callback data
										error

								cm1OpsQueue.swapOut(callbackOp).finally () ->
									callbackOp._d.resolve()
									return
								# callbackOp.callback = callback

								# jsBridge.send 'Running chain of ' + repo.length + ' ops... -> ' + JSON.stringify(repo.map (op) -> op.type())

	

					catch e
						jsBridge.send String e

					# End of "Do"
					true

			catch e
				jsBridge.send String e
				callback String e
				throw String e
				# lastRunningOp: (op) ->
				# 	cm1OpsQueue.lastOp op if op
				# 	cm1OpsQueue.lastOp() ? $q.when()
				# swapOut: (op) -> cm1OpsQueue.swapOut op
				# commitOps: {}


			# requestOps = repo
			# opPromises = $q.all( op.done() for op in repo ).then (args) ->
			# 	jsBridge.send 'Mode and Range got done!'
			# 	return args

			# Collect ops into commits


			# jsBridge.send 'attempting 1st reduce of ' + repo.length + ' op/s... '
			# # op.id 777 for op in repo
			# # reverseRepo = [].concat( repo ).reverse()
			# repo = repo.reduce ( prev, op, idx, arr ) ->
			# 	try
			# 		prevOp = repo[idx - 1]
			# 		prevOpID = if prevOp and prevOp.commit then prevOp.commit.id else null

			# 		id = if op.commit then op.commit.id else null
			# 		# run = op.run
			# 		repoCheckOp = null

			# 		if id?
			# 			if id isnt prevOpID
			# 				op.chainID 			= id
			# 				repoCheckOp 		= new CMOperation cm1
			# 				repoCheckOp.type 	= () -> 'checkRepo'
			# 				repoCheckOp.chainID = id
			# 			else
			# 				op.chainID = prevOp.chainID

			# 		# jsBridge.send 'got here 1 ' + JSON.stringify(prev)
			# 		prev.push repoCheckOp if repoCheckOp
			# 		prev.push op
			# 		# jsBridge.send 'got here 2'
			# 		if repoCheckOp
			# 			repoCheckOp.run = () ->
			# 				try
			# 					jsBridge.send '*** Checking for duplicate commits with ID: ' + id + '...***'
			# 					if cm1Repo.getChangeOrCommit(id) then throw '*** Changes/commits found! Yikes. ***'
			# 					jsBridge.send '*** No duplicate changes/commits found in the repo. ***'

			# 					repoCheckOp._done.resolve {}

			# 				catch e
			# 					repoCheckOp._done.reject String e
			# 				return

			# 		else
			# 			repoCheckOp = prev.filter( (op) -> op.commit and op.commit.id is id )[0]
			# 			repoCheckOp = prev[ prev.indexOf(repoCheckOp) - 1 ]


			# 	catch e
			# 		jsBridge.send String e

			# 	prev

			# , []


			# jsBridge.send 'Attempting 2nd reduce of ' + repo.length + ' op/s... '


			# repo = repo.reduce ( prev, op, idx, arr ) ->
			# 	try
			# 		# prevOp = repo[idx + 1]
			# 		# prevOpID = if prevOp then prevOp.id() else null

			# 		nextOp = repo[idx + 1]
			# 		nextOpID = if nextOp and nextOp.commit.id then nextOp.commit.id else null

			# 		id = if op.commit then op.commit.id else null
			# 		# run = op.run
			# 		commitOp = null

			# 		if id?
			# 			if id isnt nextOpID
			# 				# op.chainID = id
			# 				commitOp = new CMOperation cm1
			# 				commitOp.type = () -> 'commit'
			# 				commitOp.chainID = op.chainID
			# 			# else 
			# 			# 	op.chainID = nextOp.chainID

			# 		prev.push op
			# 		prev.push commitOp if commitOp

			# 		if commitOp

			# 			# commitChain.shift()
			# 			# commitChain.pop()

			# 			commitOp.run = (deps) ->
			# 				try
			# 					c = deps[0].commit
			# 					jsBridge.send 'Pushing commit with ID: ' + c.id
			# 					cm1Repo.addAndCommit new MGITCommit c.id
			# 					commitOp._done.resolve()

			# 				catch e
			# 					commitOp._done.reject String e
			# 					jsBridge.send String e

			# 				return

			# 			commitChain = repo.filter (op) -> op.chainID and op.chainID is commitOp.chainID
			# 			commitChain.shift()
			# 			commitChain.pop()
			# 			# jsBridge.send 'commit chain: ' + JSON.stringify( commitChain.map (op) -> op.type() )
			# 			commitOp.deps.push op.done() for op in commitChain

			# 	catch e
			# 		jsBridge.send String e
			# 	prev

			# , []



			# for op, idx in repo
			# 	try
				
			# 		prevOp = repo[idx - 1]


			# 		if prevOp



			# 			cid = op.chainID
			# 			if cid? and cid is prevOp.chainID

			# 				cm1OpsQueue.connectOps prevOp, 'then', op


			# 			else
			# 				jsBridge.send 'Should NOT SEE THIS!!!!.......'
			# 				# TODO: Can this return a then?
			# 				cm1OpsQueue.connectOps prevOp, 'finally', op

			# 	catch e
			# 		jsBridge.send String e
			
			# repo = repo.reduce ( prev, op, idx, arr ) ->
			# 	try
			# 		# jsBridge.send 'idx: ' + idx

			# 		# prevOp = repo[idx + 1]
			# 		# prevOpID = if prevOp then prevOp.id() else null

			# 		nextOp = repo[idx - 1]
			# 		nextOpID = if nextOp then nextOp.id() else null

			# 		id = op.id()

			# 		commitChain = () -> prev.filter (op) -> op.id() is id

			# 		# if x3.filter( (op) -> id == op.id() ).length > 0 and id isnt lastOp.id()
			# 		# 	error = 'Non-contigous commit IDs: ' + JSON.stringify( op.id for op in repo )
			# 		# 	break
			# 		jsBridge.send 'comparing ' + id + ' and ' + prevOpID
			# 		if not prevOp and id isnt prevOpID

			# 			commitOp = new CMOperation cm1

			# 			commitOp.id id

			# 			commitOp.__run = (deps) ->
			# 				try
			# 					deps = [].concat deps
			# 					# jsBridge.send 'deps should NOT be zero: ' + deps
			# 					c = new MGITCommit @id()
			# 					# jsBridge.send 'Preparing to push commit...'
			# 					jsBridge.send 'Pushing commit with ID: ' + c.id
			# 					cm1Repo.addAndCommit c
			# 				catch e
			# 					jsBridge.send String e
			# 				@_postData.resolve {}
			# 				return

			# 			prev.unshift commitOp


			# 		prev.unshift op


			# 		if id? and id isnt nextOpID
			# 			checkRepoOp = new CMOperation cm1

			# 			checkRepoOp.id id

			# 			checkRepoOp.__run = () ->
			# 				try
			# 					# deps = [].concat deps
			# 					jsBridge.send 'Checking for duplicate commits with ID ' + @id()

			# 					if cm1Repo.getChangeOrCommit @id()
			# 						jsBridge.send 'Changes/commits found! Yikes.'
			# 						@_done.reject 'Changes/commits found! Yikes.'
			# 					else
			# 						jsBridge.send 'No duplicate changes/commits found.'

			# 				catch e
			# 					jsBridge.send String e

			# 				@_postData.resolve {}
			# 				return


			# 			c.addDependency checkRepoOp for c in commitChain()
			# 			prev.unshift checkRepoOp
					

			# 		commitToRepoOp = [].concat( commitChain() ).reverse()[0]
			# 		commitToRepoOp.addDependency op if commitToRepoOp and not commitToRepoOp.hasDependency(op)

					
			# 	catch e
			# 		jsBridge.send String e

			# 	prev
			# , []

			# jsBridge.send 'Op processing completed!'





			

			# promises[0].then () =>
			# 	jsBridge.send 'Mode got done!'
			# 	return

			# promises[1].then () =>
			# 	jsBridge.send 'Range got done!'
			# 	return

			# testPromise.then () =>
			# 	jsBridge.send 'k;lk;lk'
			# 	return

			# try
			# 	# allOpsDone = $q.all( repo.map (op) => op.done() )

			# 	callbackOp = new CMOperation cm1
			# 	callbackOp.type = () -> 'callbackOp'
			# 	callbackOp.callback = callback

			# 	callbackOp.run = (rops) ->
			# 		try
					
			# 			# rops = rops[0] if Array.isArray rops
			# 			# opPromises.then (ops) =>
			# 			if rops
			# 				data = {}
			# 				data.requests = rops
			# 			else
			# 				throw 'rops was bad'

			# 			logRequestsDEBUG 'registerHandler response: ', data
			# 			# jsBridge.send 'got this far 3'
			# 			@_done.resolve callbackOp.callback data
			# 		catch e
			# 			# data = false
			# 			jsBridge.send String e
			# 			@callback String e
			# 			@_done.reject 'callbackOp: Something went real bad wrong.'
						

			# 		# jsBridge.send 'Sending back ' + JSON.stringify(data)
					

			# 		return

				# repo.push callbackOp


				# ropsDone = $q.all requestOps.reduce (prev, op) ->
				# 	prev.push op.done()
				# 	prev
				# , []

				# secondTolastOp = repo[repo.length - 2]

				# $q.all( [ropsDone, secondTolastOp.done()] ).then (args) ->
				# 	jsBridge.send 'args: ' + JSON.stringify(args[0])
				# 	callbackOp.run args[0]
				# 	return
				# , (error) ->
				# 	jsBridge.send 'callbackOp: Op chain failed. Sending back error message with callback.'
				# 	callbackOp.callback error
				# 	callbackOp._done.reject error
				# 	return

				
				# repoRun = repo[0].run
				# cm1.opsRepo.addOp repo
				# cm1OpsQueue.addOp repo
				

				# h = cm1OpsQueue.hook()
				# cm1OpsQueue.addOp repo

				# cm1OpsQueue.swapOut(callbackOp).finally () ->
				# 	repo[0].run()
				# 	return

			# catch e
			# 	jsBridge.send String(e)
			return



		$('html, body, .ng-view').css
			'width': '100%'
			'height': '100%'
			'padding': '0'
			'margin': '0'
		# jsBridge.send 'got here (Controller)'

		logRequestsDEBUG = (label, data, string='') =>
			# do () ->
			# string = ''
			for op in data.requests
				if op._type == 'parse'
					string = string + op.toJSON().tokens.length + ' tokens.\n'
				else
					string = string + JSON.stringify(op) + '\n'
			jsBridge.send label + ' ' + string if string.length > 0
			return

		# cm1.signals.change.next().then (cm, change) ->
		# 	jsBridge.send 'next 1'
		# 	return

		# cm1.signals.change.next().then (cm, change) ->
		# 	jsBridge.send 'next 2'
		# 	return

		# cm1.signals.change.next().then (cm, change) ->
		# 	jsBridge.send 'next 3'
		# 	return

		# cm1.signals.change.s().then (args) =>
		# 	jsBridge.send 'Doc value changed -> -> -> ' + args.change + ' ' + JSON.stringify(cm1.doc.getValue().length)
		# 	return

		cm1.signals.change.else().then (args) =>
			cm 		= args.cm
			change 	= args.change
			jsBridge.send 'change else -> -> -> ' + JSON.stringify(cm1.doc.getValue().length)
			return

			try
				# jsBridge.send 'starting rop...'
				rop = new CMRangeOp cm1
				rop.run = () =>

					data = {}
					data.type = rop._type
					data.string = change.text.join '\n'
					data.oldString = change.removed.join '\n'
					data.range = new CSRange cm.doc.indexFromPos(change.from), data.string.length

					rop._postData.resolve data
					return


				rop._done = $q.defer()

				rop.done().then (rop) =>

					data = {}
					data.requests = [].concat rop

					logRequestsDEBUG 'callHandler outgoing ops: ', data
					jsBridge.callHandler 'action', data, () =>
						rop._done.resolve rop
						return
					return

				# rop.done = () => d.promise

				cm1OpsQueue.addOp rop

			catch e
				jsBridge.send String(e)

			return


		cm1.signals.cursorActivity.else().then (args) ->
			try
				jsBridge.send 'cursorActivity else -> -> -> ' + cm1.doc.getValue().length + ' ' + JSON.stringify(args.cursorActivity)

				cursorActivity 	= args.cursorActivity
				ranges 			=  cursorActivity.ranges if cursorActivity
				oldRanges 		=  cursorActivity.oldRanges if cursorActivity
				return
				if ranges and oldRanges
		
					# Setup selected ranges op with prepoulated data
					do (data={}, sop = new CMSelectedRangesOp( cm1 )) ->
						
						# sop.commit = {}
						# sop.commit.id = commit.id
						sop.p = sop.p.then () ->

							# data = {}
							data.type = sop.type()
							data.ranges = ranges
							data.oldRanges = oldRanges

							sop._done.resolve data
							return


					do (commitOp = new CMOperation(cm1), commit = new MGITCommit()) ->

						# commitOp.id commit.id
						commitOp.run = () ->
							try
								cm1Repo.addAndCommit commit
							catch e
								jsBridge.send String(e)
							commitOp._done.resolve()
							return

						cod = $q.all [ commitOp.done(), sop.done() ]
						# cor = commitOp.run

						commitOp.done = () -> cod
						return

					sop.done().then () ->
						commitOp.run()
						return


					callbackOp = new CMOperation cm1
					callbackOp.run = (data) ->
						logRequestsDEBUG 'callHandler outgoing ops: ', data

						jsBridge.callHandler 'action', data, () ->
							callbackOp._done.resolve true
							return

						return

					# copRun = callbackOp.run
					$q.all( [ sop.done(), commitOp.done() ] ).then (args) ->
						callbackOp.run args[0]
						return


					h = cm1OpsQueue.hook()
					cm1OpsQueue.addOp [sop, commitOp, callbackOp]
					h.finally () ->
						sop.run()
						return

			catch e
				jsBridge.send String(e)

			return



		cm1.signals.cursorActivity.s().then (args) =>
			# jsBridge.send 'cursorActivity -> -> -> ' + JSON.stringify(cm1.doc.getValue().length)
			return
		# cm1.signals.change.next().then (cm, change) ->
		# 	jsBridge.send 'next 4'
		# 	return

		# cm1.signals.change.next().then (cm, change) ->
		# 	jsBridge.send 'next 5'
		# 	return

		# cm1.on 'cursorActivity', (cm, change, caChange) ->

			# srops = cm1.opsRepo.filter( (op) -> if op._type == 'selectedRanges' then true else false )
			# srop = srops[0] if srops.length > 0

			# if not srop and caChange.oldRanges
			# 	srop = new CMSelectedRangesOp cm1

			# 	srop._done.resolve
			# 		ranges: caChange.ranges
			# 		oldRanges: caChange.oldRanges

				# cm1.addOp srop
				# rop.range new CSRange( cm1.doc.indexFromPos(change.from), rop.string().length )

				# srop._cursorActivityFactory = () ->
				# 	d = $q.defer()
				# 	d.resolve()
				# 	d.promise

			# return
		jsBridge.send 'calling ready...'
		jsBridge.send 'readyy'
		jsBridge.send 'Ready called!'

		return

	return


.constant 'routes',
	[
		controller: 'MyCtrl1'
		resolve:
			jsBridge: (jsBridge) ->
				jsBridge
			JQueryReady: (JQueryReady) ->
				JQueryReady
			# CM: ['CM', (CM) ->
			# 	CM
			# ]
	]

