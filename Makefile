DIR_SIM=CM_IS_simulation
DIR_DATA=$(DIR_SIM)/data
EXEC_STATISTICS=./util/statistics.py
FORCES=strong-strong media-media weak-weak strong-media media-strong strong-weak weak-strong media-weak weak-media

#all: data $(FORCES)
#	./start-sim.sh
all: clean data $(FORCES)

$(FORCES): %:
	cd $(DIR_SIM) && make strength=$@
	python3 $(EXEC_STATISTICS) $@

data:
	cd $(DIR_DATA) && make

clean:
	rm -rf statistics
	cd $(DIR_SIM) && make clean
	cd $(DIR_DATA) && make clean

.PHONY: all data clean $(FORCES)