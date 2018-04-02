VERSIONS:=sequentiel parallel
NODES:=4
ROOM:=
TIME:=time -f "%e %C" -ao times.csv

all: sequentiel parallel

parallel: hostfile
	$(MAKE) -C parallel

sequentiel: hostfile
	$(MAKE) -C sequentiel

times: hostfile parallel
	@echo -n "" > times.csv
	@$(TIME) $(MAKE) NODES=$(NODES) -sC parallel test2
	@$(TIME) $(MAKE) NODES=$(NODES) MODE=--async -sC parallel test2
	@$(TIME) $(MAKE) NODES=$(NODES) MODE=--blocks -sC parallel test2
	@$(TIME) $(MAKE) NODES=$(NODES) MODE="--blocks --async" -sC parallel test2
	@cat times.csv

hostfile:
	./make_hostfile.sh $(ROOM)

testSave:
	@for v in $(VERSIONS); do $(MAKE) -C $$v testSave; done
	diff ./sequentiel/bin/shalw_512x512_T40.png ./parallel/bin/shalw_512x512_T40.png

clean:
	@for v in $(VERSIONS); do $(MAKE) -C $$v clean; done

mrproper:
	@for v in $(VERSIONS); do $(MAKE) -C $$v mrproper; done
	rm times.csv hostfile

.PHONY: parallel sequentiel times testSave clean mrproper