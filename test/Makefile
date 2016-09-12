all:
	cd test-logic      && make
	cd test-shift      && make
	cd test-move       && make
	cd test-arithmetic && make
	cd test-jump       && make
	cd test-branch     && make
	cd test-memory     && make
	cd test-stall      && make
	cd test-forwarding && make
	cd test-yamin      && make
	@printf "\033[92;1m==>\033[0m all tests passed.\n"

clean:
	rm -rf */dump.vcd