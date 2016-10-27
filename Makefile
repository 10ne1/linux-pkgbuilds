clean-stable:
	rm -rf *linux-stable*tar.xz linux.install.pkg pkg/

clean-rt:
	rm -rf *linux-rt*tar.xz linux.install.pkg pkg/

clean-src:
	rm -rf src/

clean-mainline:
	rm -rf *linux-mainline*tar.xz linux.install.pkg pkg/

clean-next:
	rm -rf *linux-next*tar.xz linux.install.pkg pkg/

clean-all: clean-rt clean-stable clean-src clean-mainline clean-next
