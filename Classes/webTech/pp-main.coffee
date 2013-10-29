root = exports ? this

root.ppEvents = $( {} )

sharedErrorBucket	= null

contentBeforeEdit 	= ''

# Globally available bridge for debugging purposes
root.ppbridge = null

# A simple, throw-away singleton to style the DOM and Code Mirror instance
class PPStyler
	constructor: () ->


	@resetCSS = ( el ) ->
		el.css 'width', '100%'
		el.css 'height', '100%'
		el.css 'padding', '0'
		el.css 'margin', '0'
		return

	@styleBody = ( bodyTag ) ->
		bodyTag.css 'background-color', '#fff'
		return

	@styleCM = ( cm, cmScroll ) ->
		cm.css 'background', '#f2f2f2'
		cm.css 'height', '2000px !important'
		cmScroll.css 'height', '2000px !important'
		cmScroll.css 'overflow-x', 'auto'
		return

$ ->
	onBridgeReady = (event) ->
		
		bridge 		= event.bridge
		ppbridge 	= bridge

		bridge.init()

		try
			myCM = CodeMirror $('body')[0],
				lineNumbers: true
				autofocus: true
				autoCloseBrackets: true
				# onKeyEvent: (cm, e) ->
				# 	$.event.fix e
				# 	return
			
		catch e
			bridge.send 'error loading CodeMirror: ' + String( e )

		try
			PPStyler.styleCM $('.CodeMirror'), $('.CodeMirror-scroll')
			PPStyler.resetCSS $('html, body')
			PPStyler.styleBody $('body')
		catch e
			bridge.send 'error styling: ' + String( e )

		if myCM
			ppEvents.trigger 'PPReady', [ myCM, bridge ]

		bridge.send 'ready'

		
		

		return

	document.addEventListener 'WebViewJavascriptBridgeReady', onBridgeReady, false

	return



# TODO: Find a globally safe event that can be setup before JQ loads
ppEvents.on 'PPReady', (e, myCM, bridge) ->
	
	sharedErrorBucket 	= new ErrorBucket()

	
	

	


	

	# bridge.registerHandler 'defaultStyle', (data, responseCallback) ->
	# 	defaultStyle = data
	# 	responseCallback true
	# 	return
	bridge.registerHandler 'tokenize', (data, responseCallback) ->

		cmContent = myCM.doc.getValue()

		mode 	= if data.mode == 'scss' then 'text/x-scss' else data.mode
		string 	= data.string

		# Verify incoming data
		if !mode
			responseCallback { errors: [ 'Error: no mode specified' ] }

		myCM.setOption 'mode', mode
		# bridge.send 'running ' + mode + ' mode on ' + string

		tokens = []
		try
			CodeMirror.runMode string, mode, (text, styleClass) ->
				if text != ' ' and text != '' and text != '\n' and text != '\t'
					tokens.push { text: text, styleClass: styleClass }
				return
			bridge.send tokens.length + ' tokens collected.'
		catch e
			bridge.send String( e )

		returnData = { 'tokens': tokens }

		responseCallback returnData

		return
		


	
	return


# Parse
ppEvents.on 'PPReady', (e, myCM, bridge) ->
	
	sharedErrorBucket 	= new ErrorBucket()


	bridge.registerHandler 'parse', (data, responseCallback) ->
		

		cmContent = myCM.doc.getValue()

		mode 	= if data.mode == 'scss' then 'text/x-scss' else data.mode
		string 	= data.string

		# Verify incoming data
		if !mode
			responseCallback { errors: [ 'Error: no mode specified' ] }

		myCM.setOption 'mode', mode



		returnData = { 'tokens': tokens }
		# if tokens.length == 0
		# 	returnData['messages'] = [ 'No tokens found.' ]

		responseCallback returnData



		return
		


	
	return


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









