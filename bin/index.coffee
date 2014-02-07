
require 'colors'

require 'coffee-script'
Manager = require __dirname + '/../lib/manager'

mgm = new Manager()

mgm.addHTTP 60001, '0.0.0.0', (-> console.log 'Listening port : 60001'.green)
mgm.addHTTP 60002, '0.0.0.0', (-> console.log 'Listening port : 60002'.green)
mgm.addHTTP 60003, '0.0.0.0', (-> console.log 'Listening port : 60003'.green)
mgm.addHTTP 60004, '0.0.0.0', (-> console.log 'Listening port : 60004'.green)

mgm.use (req) ->
	console.log 'Middleware step 1'

mgm.use (req) ->
	console.log 'Middleware step 2'

mgm.addTCP 60021, '0.0.0.0', (-> console.log 'Listening TCP port : 600021')

# mgm.use (req) ->
# 	console.log 
# 		remoteAddress: req.socket.remoteAddress,
# 		remotePort: req.socket.remotePort,
# 		localAddress: req.socket.localAddress,
# 		localPort: req.socket.localPort

# mgm.use (req, res) ->
# 	res.write 'You come from : ' + req.socket.localAddress + ':' + req.socket.localPort
# 	console.log req.headers