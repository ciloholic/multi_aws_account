# https://gist.github.com/tadashi-aikawa/da73d277a3c1ec6767ed48d1335900f3
.PHONY: $(shell egrep -oh ^[a-zA-Z0-9][a-zA-Z0-9\/_-]+: $(MAKEFILE_LIST) | sed 's/://')

update:
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate terraform -r /root/src
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate provider aws -r /root/src
lock:
	@docker run -it --rm -v $$(pwd):/root/src minamijoyo/tfupdate lock -r --platform=linux_amd64 --platform=darwin_amd64 --platform=darwin_arm64 .
