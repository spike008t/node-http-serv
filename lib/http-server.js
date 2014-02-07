
var http = require('http');
var ports = [60001, 60002, 60003, 60004];
var servers = [];
var s;

function reqHandler(req, res) {
	console.log({
		remoteAddress: req.socket.remoteAddress,
		remotePort: req.socket.remotePort,
		localAddress: req.socket.localAddress,
		localPort: req.socket.localPort
	});
}

ports.forEach(function (port) {
	s = http.createServer(reqHandler);
	s.listen(port);
	servers.push(s);
});