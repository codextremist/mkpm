ifndef mkpm_bootstraped
.PHONY: mkpm_bootstrap
Makefile: mkpm_bootstrap
	@cp -n $@ $@.old
	@curl -sL https://raw.githubusercontent.com/codextremist/mkpm/refs/heads/master/bootstrap.mk > mkpm_bootstrap && \
	{ cat mkpm_bootstrap; sed '/^ifndef mkpm_bootstraped/,/^endif/d' $@; } > $@.new && \
	mv $@.new $@ && rm mkpm_bootstrap
endif