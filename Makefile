.PHONY: build all doc install release clean postconf tag

version = 1.1.1
fullname = netamqp-$(version)

trunk = https://godirepo.camlcity.org/svn/lib-netamqp/trunk
tag = https://godirepo.camlcity.org/svn/lib-netamqp/tags/netamqp-$(version)


build:
	omake

all:
	omake

doc:
	omake doc/html

install:
	ocamlfind install netamqp2 \
		META *.mli *.cmi netamqp.cma amqp0-9-1.xml \
		-optional netamqp.cmxa netamqp.a \
		-patch-version "$(version)"

clean:
	omake clean

postconf:
	echo 'pkg_version="$(version)"' >>setup.data


# Note that the files netamqp_method_0_9.ml* are generated. For running
# the generator we need PXP, though, so by distributing the generated
# files we avoid this dependency.

FILES = \
  netamqp_basic.mli \
  netamqp_basic.ml \
  netamqp_channel.mli \
  netamqp_channel.ml \
  netamqp_connection.mli \
  netamqp_connection.ml \
  netamqp_endpoint.mli \
  netamqp_endpoint.ml \
  netamqp_exchange.mli \
  netamqp_exchange.ml \
  netamqp_queue.mli \
  netamqp_queue.ml \
  netamqp_rtypes.mli \
  netamqp_rtypes.ml \
  netamqp_transport.mli \
  netamqp_transport.ml \
  netamqp_tx.mli \
  netamqp_tx.ml \
  netamqp_types.mli \
  netamqp_types.ml \
  amqp_gen.ml \
  amqp0-9-1.xml \
  META \
  Makefile \
  OMakefile \
  OMakeroot \
  INSTALL \
  LICENSE

release: all doc
	mkdir -p release
	rm -rf release/$(fullname)
	mkdir release/$(fullname)
	mkdir release/$(fullname)/doc
	mkdir release/$(fullname)/doc/html
	mkdir release/$(fullname)/examples
	cp $(FILES) release/$(fullname)
	cp examples/*.ml release/$(fullname)/examples
	cp doc/html/*.html release/$(fullname)/doc/html
	cp doc/html/*.css release/$(fullname)/doc/html
	cp doc/*.pdf release/$(fullname)/doc
	cd release && tar czf $(fullname).tar.gz $(fullname)
