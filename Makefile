default: both

client:
	love src/

server:
	love src/ --server

both:
	love src/ --server&
	sleep 0.2
	love src/ &

two-clients:
	sleep 0.2
	love src/ &
	sleep 0.2
	love src/ &

three:
	love src/ --server&
	sleep 0.2
	love src/ &
	sleep 0.2
	love src/ &

