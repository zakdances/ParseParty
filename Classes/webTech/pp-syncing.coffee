root = exports ? this
# root.externalTestFunc = ->
# 		"I'm returned!"

myCodeMirror 		= null
bridge 				= null
# inlineLog 			= null
sharedErrorBucket	= null

changeRepo 			= null
suppliedChange 		= null
# didChangeManually = true
defaultStyle 		= null
contentAttributes 	= []
contentBeforeEdit 	= ''

$ ->
	onBridgeReady = (event) ->
		
		bridge = event.bridge
		bridge.init()

		ready()

		return

	document.addEventListener 'WebViewJavascriptBridgeReady', onBridgeReady, false

	return

ready = () ->

	textArea = $('<textarea></textArea>')
	$('body').append textArea
	textArea.keydown (e) ->
		
		bridge.send 'madison county'
		return


	testType = () ->
		bridge.send 'dummy type...'
		try
			
			myCodeMirror.readOnly = true
			input = $( myCodeMirror.getInputField() )

			kc = 219
			e = $.Event 'keydown',
				which: kc
				keyCode: kc
			# e = $.Event 'keypress', { which: kc }
			# e = $.Event 'keyup', { which: kc }
			

			# $( myCodeMirror.getWrapperElement() ).children().each (index) ->
			# 	bridge.send 'trying....'
			# 	$(this).trigger e
			# 	return
			input.trigger e
			# textArea.trigger e

			# input.val '['
			# input.change()
			# simulateKey myCodeMirror, 219

		catch e
			bridge.send String( e )
		return
	setInterval testType, 2000


	changeRepo 			= new MGITRepository()
	sharedErrorBucket 	= new ErrorBucket()

	# bridge = event.bridge
	# bridge.init()

	
	resetCSS()
	styleBody()
	


	try
		myCodeMirror = CodeMirror $("body")[0],
			lineNumbers: true
			autofocus: true
			autoCloseBrackets: true
			onKeyEvent: (cm, e) ->
        		$.event.fix e
		styleCodeMirror()

		# log 'CodeMirror loaded.'
	catch e
		bridge.callHandler 'log', {'message': 'error loading CodeMirror: ' + String( e ) }, (response) ->
			return



	# bridge.send 'ready'

	# bridge.callHandler 'jqOnReady', {'foo': 'bar'}, (response) ->
	# 	return
	bridge.send 'ready'

	bridge.registerHandler 'defaultStyle', (data, responseCallback) ->
		defaultStyle = data
		responseCallback true
		return

	bridge.registerHandler 'CodeMirrorCommand', (data, responseCallback) ->
		# didChangeManually = false
		error = null
		# responseData = new DataForXcode()

		doc 			= myCodeMirror.getDoc()
		currentContent 	= doc.getValue()
		currentMode 	= myCodeMirror.getOption 'mode'	
		

		

		# data from Xcode
		# ----------------

		change = Commit.changeFromJSON( data.change )

		mode 			= if data.syntax == 'scss' then 'sass' else data.syntax
		editedRange 	= change.editedRange # editedRange.location / editedRange.length
		changeInLength 	= change.changeInLength
		editedSubstring = change.editedSubstring

		# ----------------

		# bridge.send 'try it: ' + JSON.stringify( change.editedSubstring.attributes )

		try
			if mode != currentMode
				myCodeMirror.setOption 'mode', mode
				# responseData.addMessage 'Mode changed to ' + mode + ' (was ' + currentMode + ')'

			editedRange.length 	= editedRange.length - changeInLength
			startPos 			= myCodeMirror.posFromIndex editedRange.location
			endPos 				= myCodeMirror.posFromIndex editedRange.location + editedRange.length



			# If incoming content doesn't match CodeMirror content...
			# if editedSubstring.string != doc.getRange startPos, endPos

			# substring 		= content.substr editedRange.location, editedRange.length
			isForwardChange = true
			for backwardChange in changeRepo.commits
				if backwardChange.id.UUIDString == change.id.UUIDString
					isForwardChange = false
				
			
			if isForwardChange == true

				suppliedChange = change

				# responseData.addBodyKey 'line', startPos.line
				# responseData.addBodyKey 'length', endPos.ch
				# responseData.addBodyKey 'editedSubstring', editedSubstring

				doc.replaceRange editedSubstring.string, { line: startPos.line , ch: startPos.ch }, { line: endPos.line , ch: endPos.ch }


				tokens = []
				CodeMirror.runMode doc.getValue(), mode, (text, styleClass) ->
					if text != ' ' and text != '' and text != '\n' and text != '\t' and tokens.length < 20
						tokens.push { text: text, styleClass: styleClass }
					return

				if tokens.length > 0
					# responseData.addBodyKey 'tokens', tokens
				else
					# responseData.addMessage 'No tokens found.'

				# catch e
				# 	response = String e
				# else
				# 	responseData.addMessage 'Content wasn\'t different, so nothing was changed.'
				

			

		catch e
			bridge.send String(e)
			# error = String( e )
			# responseData.addError String( error )

		if !error
			pass = 'yes'
			# responseData.addBodyKey 'content', doc.getValue()

		# responseCallback responseData.makeBody()
		responseCallback true

		# didChangeManually = true
		return

	myCodeMirror.on 'keydown', (cm, event) ->
		bridge.send 'waaaaaah YES'
		return
	
	
	myCodeMirror.on 'change', (cm, changeData) ->
		sharedErrorBucket.reset()

		# if didChangeManually
		doc 	= cm.getDoc()
		content = doc.getValue()
		cA 		= contentAttributes

		charAttributesToMerge = []

		if suppliedChange
			change = suppliedChange
			suppliedChange = null;



		else
			
			changeInLength 	= content.length - contentBeforeEdit.length

			location		= doc.indexFromPos( changeData.from )
			length			= location + changeData.text.join('').length
			if location + length > content.length
				length = ( location + length ) - content.length

			editedPlainSubstring = doc.getRange doc.posFromIndex(location), doc.posFromIndex(location + length)
			
			
			change 					= new Commit()
			change.editedRange 		= new NSRange( location, length )
			change.changeInLength 	= changeInLength
			change.editedSubstring 	= new NSAttributedString( editedPlainSubstring )
			# bridge.send 'try this out 2' + String( change.changeInLength ) + ' ' + changeData.text.join('').length
			# bridge.send 'tryin'
			# try
				
			# catch e
			# 	
			# 	sharedErrorBucket.addMessage 'error: ' + String( e )
			# 	sharedErrorBucket.armed = true

			try
				
				lastAttrs = if cA.length > 0 then cA[change.editedRange.location - 1] else defaultStyle
				# lastAttrs = changeRepo.attributesForChar change.editedRange.location - 1
				
				
				

				for char, index in change.editedSubstring.string.split ''

					newAR 				= new NSAttributedRange( index, 1 )
					charSuperLocation 	= change.editedRange.location + index
					existingAttrs		= contentAttributes[charSuperLocation]

					attrs = if typeof existingAttrs isnt 'undefined' then existingAttrs else lastAttrs
					
					

					# $.extend newAR.attributes, changeRepo.attributesForChar( change.editedRange.location + index )
					# attrs = changeRepo.attributesForChar( change.editedRange.location + index )
					# len = Object.keys( attrs ).length
					# availAttrsCount = Object.keys( newAR.attributes ).length
					# if Object.keys( attrs ).length > 0
					# 	sharedErrorBucket.addMessage 'overlapping attributes found.'
					# else
					# 	# bridge.send 'whu ' + JSON.stringify( new NSRange( change.editedRange.location + index, 1 ) ) + '\nhuh: ' + JSON.stringify( newAR.attributes )

					# 	# bridge.send 'huh2: ' + JSON.stringify( lastAttrs )
					# 	# newAR.attributes.push a for a in lastAttrs
					# 	sharedErrorBucket.addMessage 'no overlapping attributes found. Applying last known attributes...\n' + JSON.stringify( lastAttrs )
					# 	$.extend attrs, lastAttrs
					bridge.send 'hmm ' + JSON.stringify( attrs )
					if !attrs or Object.keys( attrs ).length == 0
						sharedErrorBucket.addMessage 'Something went wrong. No attributes could be found or created.' if Object.keys( attrs ).length == 0
						sharedErrorBucket.armed = true

					$.extend newAR.attributes, attrs

					change.editedSubstring.attributedRanges.push newAR

			catch e
				bridge.send 'huh ' + String( e )
				sharedErrorBucket.addMessage 'error: ' + String( e )
				sharedErrorBucket.armed = true
		

		# update content attribute array
		
		for AR in change.editedSubstring.attributedRanges
			for i in [0...AR.length]
				loc = change.editedRange.location + i
				existingAttrs = cA[loc]
				if existingAttrs
					$.extend existingAttrs, AR.attributes
				else
					cA[loc] = AR.attributes
				
				# $.extend( existingAttrs, AR.attributes ) if existingAttrs else cA[location] = AR.attributes


		# bridge.send 'contentAttrs(' + contentAttributes.length + ')'
		# for thing in contentAttributes
		# 	bridge.send JSON.stringify( thing ) + '\n'

			

		for thing in contentAttributes when typeof thing is 'undefined'
			sharedErrorBucket.addMessage 'ERROR ERROR ERROR: null is in contentAttributes'
			sharedErrorBucket.armed = true
		
		
		
			

		contentBeforeEdit = cm.getDoc().getValue()
		change.applied = true;
		

		changeRepo.stageAndCommit change

		# for ARs in ( c.editedSubstring.attributedRanges for c in changeRepo.commits )
		# 	for AR in ARs
		# 		bridge.send 'new change with range ' + JSON.stringify( new NSRange( AR.location, AR.length ) )
		# data = new DataForXcode()


		# data.addBodyKey 'content', content
		
		data =
			'change': change.toJSON()
		bridge.callHandler 'codeMirrorChanged', data, (response) ->
			return


		sharedErrorBucket.printWith( bridge.send ) if sharedErrorBucket.armed
		sharedErrorBucket.reset()
		return
	
	

		




	# End of bridge init
	return




# setTimeout () ->
	
# 	if typeof window.Cocoa is not 'undefined'
# 		window.Cocoa.log 'external script success!!'


# 	try
# 		window.Cocoa.log 'weird type external script success!!'
		
# 	catch e
# 		console.log e
	
# 	return
# , 3000




# ready = () ->



# 	return


class MGITRepository
	constructor: (@commits=[], @capacity=100) ->

	stageAndCommit: (change) ->
		@commits.shift() if @commits.length >= @capacity
		@commits.push change

	attributedRangesWithGlobalCoordinates: () ->
		things = []
		for change in @.commits
			editedRange = change.editedRange
			ARs = change.editedSubstring.attributedRanges
			# for AR in ARs
			# 	bridge.send 'AR coord ' + JSON.stringify( new NSRange( AR.location, AR.length ) )
			# for AR in $.extend true, [], ARs
			# 	AR.location = editedRange.location + AR.location
			# 	things.push AR
			for AR in ARs
				AR = new NSAttributedRange( editedRange.location + AR.location, AR.length, $.extend true, [], AR.attributes )
				# AR.location = editedRange.location + AR.location
				things.push AR
		things

	# allAttributedRanges: () ->
	# 	[].concat.apply( [], ( c.editedSubstring.attributedRanges for c in @.commits ) )

	attributedRangesForChar: (charLocation) ->

		myArrRangs = []

		# newAR = new NSAttributedRange( charLocation, 1 )

		attributedRanges = @.attributedRangesWithGlobalCoordinates()

		hmm = ( [AR.location...AR.location + AR.length] for AR in attributedRanges )
		sharedErrorBucket.addMessage 'searching for ' + charLocation + ' in ' + JSON.stringify( hmm )

		for AR in attributedRanges when [AR.location...AR.location + AR.length].indexOf(charLocation) >= 0
			myArrRangs.push( AR ) 
		myArrRangs

	attributesForChar: (charLocation) ->

		myArr = {}
		
		$.extend myArr, attributedRange.attributes for attributedRange in @.attributedRangesForChar( charLocation )

		myArr

class UUID
	constructor: (@UUIDString=UUID._generateUUIDString()) ->

	@_generateUUIDString: () ->
		uuid.v1()
		# _p8 = (s) ->
		# 	p = ( Math.random().toString(16)+"000000000" ).substr(2,8)
		# 	# return s ? "-" + p.substr(0,4) + "-" + p.substr(4,4) : p
		# 	if s then "-" + p.substr(0,4) + "-" + p.substr(4,4) else p
		# _p8() + _p8(true) + _p8(true) + _p8()


class NSRange
	constructor: (@location, @length) ->

	# intersectsWith: () ->
	# 	return

class NSAttributedRange extends NSRange
	constructor: (@location, @length, @attributes={}) ->

class NSAttributedString
	constructor: (@string, @attributedRanges=[]) ->

class Commit
	constructor: (@id=new UUID(), @editedRange, @changeInLength, @editedSubstring, @applied=false) ->

	@changeFromJSON: (data) ->
		change 					= new Commit( new UUID( data.id.UUIDString ) )
		change.editedRange 		= ( new NSRange(data.editedRange.location, data.editedRange.length) )
		change.changeInLength 	= data.changeInLength
		change.editedSubstring 	= ( new NSAttributedString(data.editedSubstring.string ) )
		for attributedRange in data.editedSubstring.attributedRanges
			change.editedSubstring.attributedRanges.push new NSAttributedRange(
				attributedRange.location,
				attributedRange.length,
				attributedRange.attributes )
		

		# bridge.send 'sending ' + change.id.UUIDString
		
		change

	toJSON: () ->
		'id':
			'UUIDString': @id.UUIDString
		'editedRange':
			'location': @editedRange.location
			'length': @editedRange.length
		'changeInLength': @changeInLength
		'editedSubstring':
			'string': @editedSubstring.string
			'attributedRanges': @editedSubstring.attributedRanges
		'applied': @applied




class ErrorBucket
	constructor: (@messages=[], @armed=false) ->

	addMessage: (message) ->
		@messages.push = message
		return

	printWith: (printer) ->
		printer JSON.stringify( @messages )
		return

	reset: () ->
		@messages.pop() while @messages.length > 0
		@armed = false
		return












# Styling CSS
resetCSS = () ->
	$("html").css 'width', '100%'
	$("html").css 'height', '100%'
	$("html").css 'padding', '0'
	$("html").css 'margin', '0'

	$("body").css 'width', '100%'
	$("body").css 'height', '100%'
	$("body").css 'padding', '0'
	$("body").css 'margin', '0'
	return

styleBody = () ->
	$("body").css 'background-color', '#fff'
	return

styleCodeMirror = () ->
	$('.CodeMirror').css 'background', '#f2f2f2'
	$('.CodeMirror').css 'height', '2000px !important'
	$('.CodeMirror-scroll').css 'height', '2000px !important'
	$('.CodeMirror-scroll').css 'overflow-x', 'auto'
	return