SHELL := $(shell which zsh)
RC_FILES := $(wildcard *rc)

links = $(RC_FILES) \
	zsh \
	gitconfig gitignore \
	tmux.conf \
	peco.json

.PHONY: clean install update

default: install
install: links shell/install
update: links shell/update
sandbox: docker/run


.PHONY: links $(links)
links: $(links)
$(links):
	@test -h ~/.$@ || ln -sf $(CURDIR)/$@ ~/.$@
	@ls -ld ~/.$@


.PHONY: shell/install shell/update
shell/install: ~/.zplug/zplug ~/.zplug/init.zsh
	@echo Setting up SEHLL
	echo $$SHELL | grep -q $(SHELL) || chsh -s $(SHELL)
	$(SHELL) --version
	-time ( source ~/.$(notdir $(SHELL))rc )

shell/update:
	$(SHELL) -c 'source ~/.zplug/zplug && zplug update --self'

~/.zplug/zplug:
	curl -sSLfo ~/.zplug/zplug --create-dirs https://git.io/zplug

~/.zplug/init.zsh:
	ln -sf $(CURDIR)/init.zplug.zsh $@


.PHONY: docker/build docker/run
docker/build:
	@eval $$(docker-machine env default) && docker build --rm -t cynipe/dotfiles .

docker/run: docker/build
	@eval $$(docker-machine env default) && docker run --rm -it \
		-v $(CURDIR):/root/src/dotfiles \
		-w /root/src/dotfiles \
		cynipe/dotfiles $(CMD)
