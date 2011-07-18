PREFIX = /usr

install : install-anymangaget install-anymangasearch

install-anymangaget : install-anymangasearch
	mkdir --parents ${PREFIX}/bin
	cp --force anymangaget ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/anymangaget

install-anymangasearch : install-urlencode
	mkdir --parents ${PREFIX}/bin
	cp --force anymangasearch ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/anymangasearch

install-urlencode :
	cd ../utils && ${MAKE} install-urlencode

uninstall : uninstall-anymangaget uninstall-anymangasearch

uninstall-anymangaget : uninstall-anymangasearch
	@echo anymangasearch was removed because anymangaget depends on it
	rm --force ${PREFIX}/bin/anymangaget

uninstall-anymangasearch :
	@echo anymangasearch depends on urlencode, but latter wasn\'t deleted because
	@echo other programs may depend on it. If you\'re certain that you don\'t need
	@echo urlencode any more, please run \'make uninstall-urlencode\' manually
	rm --force ${PREFIX}/bin/anymangasearch

uninstall-urlencode : 
	cd ../utils && ${MAKE} uninstall-urlencode

.PHONY : install install-anymangaget install-anymangasearch \
         install-urlencode uninstall uninstall-anymangaget \
         uninstall-anymangasearch uninstall-urlencode

