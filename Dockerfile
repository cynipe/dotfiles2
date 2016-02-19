FROM buildpack-deps:jessie-scm

RUN apt-get update -y && apt-get install -y \
		zsh \
		make \
		vim \
		locales \
	&& rm -rf /var/lib/apt/lists/*

RUN chsh -s /usr/bin/zsh

RUN sed -ri 's!# ((en_US|ja_JP).UTF-8)!\1!' /etc/locale.gen && locale-gen

ENV SHELL /usr/bin/zsh

WORKDIR /root
ENTRYPOINT /usr/bin/zsh
