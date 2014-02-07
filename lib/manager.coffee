
require 'colors'
http = require 'http'
net = require 'net'

###*
 * Manager class, this call will manage the differents http server
 * @type {manager}
###
module.exports = class manager
	###*
	 * Constructor
	 * @return {[type]}
	###
	constructor: ->
		console.log 'init'
		@interfaces = {}
		@middlewares = [];

	_requestHandler: (request, response, name) ->
		console.log 'new request detected'
		fn(request, response, name) for fn in @middlewares

	###*
	 * Add a http server
	 * @param {Integer}   port The port to listen
	 * @param {String}    ip The IP adress to listen (default: 0.0.0.0)
	 * @param {Function}  callback called with err as param if an error occured
	###
	addHTTP: (port, ip, callback) ->

		ip = ip || '0.0.0.0'
		name = ip + ':' + parseInt(port, 10)

		# TODO check if the ip is a valid ip
		_interface = @interfaces[ip] || {
			ip: ip,
			port: port,
			name: name,
			sock: null,
			state: 0,
			type: 'http'
		}

		# if the port is not listening so listen
		if _interface.state is 0
			sock = http.createServer (req, res) =>
				console.log '[HTTP] Request detected from : ' + name
				@_requestHandler req, res, name

			sock.listen port, ip, =>
				_interface.state = 1

			sock.on 'close', =>
				_interface.state = 0

			_interface.sock = sock
		else # if the port is already on listening, skip
			console.warn 'The port ' + ip + ':' + port + ' is already listening'

		if typeof callback is 'function'
			callback(null, _interface) 

		@interfaces[ip] = _interface
		return true


	_tcpHandler: (client) =>
		fn(client) for fn in @middlewares

	addTCP: (port, ip, callback) ->

		ip = ip || '0.0.0.0'
		name = ip + ':' + parseInt(port, 10)

		# TODO check if the ip is a valid ip
		_interface = @interfaces[ip] || {
			ip: ip,
			port: port,
			name: name,
			sock: null,
			state: 0,
			type: 'tcp'
		}

		# if the port is not listening so listen
		if _interface.state is 0
			sock = net.createServer (client) =>
				console.log '[TCP] Connection detected : ' + name
				@_tcpHandler client

			sock.listen port, ip, =>
				_interface.state = 1

			sock.on 'close', =>
				_interface.state = 0

			_interface.sock = sock


		else # if the port is already on listening, skip
			console.warn 'The port ' + ip + ':' + port + ' is already listening'

		if typeof callback is 'function'
			callback(null, _interface) 

		@interfaces[ip] = _interface
		return true


	use: (fn) ->
		if typeof fn isnt 'function'
			msg = 'The argument must be a function but ' + typeof(fn) + ' given'
			console.error msg
			throw new Error msg
			return false

		# if @middlewares.indexOf fn isnt -1
		# 	msg = 'The current function already exist. Skipped.'
		# 	console.warn msg
		# 	return true

		@middlewares.push fn
		return true
