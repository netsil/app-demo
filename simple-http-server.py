#!/usr/bin/python
# Based from https://www.acmesystems.it/python_http
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
import json

PORT_NUMBER = os.environ.get(WEB_APP_SERVER_PORT, '8080')

#This class will handles any incoming request from
#the browser 
class myHandler(BaseHTTPRequestHandler):
	
	#Handler for the GET requests
	def do_GET(self):
		try:
			sendReply = False
			if self.path.endswith("/"):
				sendReply = True
			if self.path.endswith("/mobile"):
				sendReply = True
			if self.path.endswith("/desktop"):
				sendReply = True
			if self.path.endswith("/laptop"):
				sendReply = True
			if self.path.endswith("netbook"):
				sendReply = True

			if sendReply == True:
				mimetype='application/json'
                                json_string = json.dumps({'path': self.path})
				#Open the static file requested and send it
				self.send_response(200)
				self.send_header('Content-type',mimetype)
				self.end_headers()
                                self.wfile.write(json_string)
			return

		except IOError:
			self.send_error(404,'File Not Found: %s' % self.path)

try:
	#Create a web server and define the handler to manage the
	#incoming request
	server = HTTPServer(('', PORT_NUMBER), myHandler)
	print 'Started httpserver on port ' , PORT_NUMBER
	
	#Wait forever for incoming htto requests
	server.serve_forever()

except KeyboardInterrupt:
	print '^C received, shutting down the web server'
	server.socket.close()
