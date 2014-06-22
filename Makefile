default: both

client:
	love src/

server:
	love src/ --server

both:
	love src/ --server&
	sleep 0.1
	love src/ &
