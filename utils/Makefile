PREFIX = /usr

install : install-htmldecode install-resolveips install-urldecode \
          install-urlencode

install-% : filename = $(subst install-,,$@)
install-% :
	mkdir --parents ${PREFIX}/bin
	cp --force ${filename} ${PREFIX}/bin
	chmod 755 ${PREFIX}/bin/${filename}

uninstall : uninstall-htmldecode uninstall-resolveips uninstall-urldecode \
            uninstall-urlencode

uninstall-% : filename = $(subst uninstall-,,$@)
uninstall-% :
	rm --force ${PREFIX}/bin/${filename}

