test:
	prove ./t

pingpong:
	cd examples/pingpong && ./run-pingpong.sh 50

sync:
	cd examples/sync-consumer-producer && ./run-synchronous.sh 1 1 

async:
	cd examples/async-consumer-producer && ./run-asynchronous.sh 1 1 
