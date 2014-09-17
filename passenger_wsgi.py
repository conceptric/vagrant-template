def application(environ, start_response):
  start_response('200 OK', [('Content-Type', 'text/plain')])
  return [b"Hello world from my basic Python app in Passenger!\n"]