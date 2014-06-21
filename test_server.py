#!/usr/bin/python3
import socketserver
import time

class Handler(socketserver.BaseRequestHandler):
	def handle(self):
		data = self.request[0].strip()
		print(data)

host, port = "localhost", 1337
server = socketserver.UDPServer((host, port), Handler)
server.serve_forever()
