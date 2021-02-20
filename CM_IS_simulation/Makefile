strength = debil-debil

NETLOGO=/opt/netLogo/netlogo-headless.sh
#NETLOGO=/Applications/NetLogo\ 6.1.1/netlogo-headless.sh

$(strength): clean
	$(NETLOGO) --threads 8 --model CM-IS-bone-difs_sistema_adaptativo.nlogo --experiment $@

clean:
	rm -f log/**/*.csv log/**/*.png