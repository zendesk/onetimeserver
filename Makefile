all:  wrapper onetimeserver-go install-local

wrapper: wrapper/wrapper.c wrapper/wrapper
	gcc -Wall -g -o wrapper/wrapper wrapper/wrapper.c

onetimeserver-go:
	go install github.com/zendesk/onetimeserver/...

DIR=${HOME}/.onetimeserver/$(shell uname -s)-$(shell uname -m)

release: onetimeserver-crossbuild
	(cd onetimeserver-binaries && git commit -am 'update onetimeserver-bins' && git push)

onetimeserver-crossbuild:
	env GOOS=linux GOARCH=386 go build -o onetimeserver-binaries/onetimeserver-go/linux/onetimeserver-go cmd/onetimeserver-go/main.go
	env GOOS=darwin GOARCH=386 go build -o onetimeserver-binaries/onetimeserver-go/darwin/onetimeserver-go cmd/onetimeserver-go/main.go

install-local:
	mkdir -p $(DIR)
	cp wrapper/wrapper $(DIR)
	cp ${GOPATH}/bin/onetimeserver-go $(DIR)


