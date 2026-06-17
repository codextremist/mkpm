-include mkpkg

_mkpm_registry ?= https://github.com/codextremist
_mkpm_pkg_main ?= Makefile

MKPKGS_DIR = .mkpkgs

define get-pkg
$(subst /, ,$1)
endef

define get-version
$(if $(word 2,$(call get-pkg,$1)),$(word 2,$(call get-pkg,$1)),latest)
endef

define get-name
$(word 1,$(call get-pkg,$1))
endef

_include := $(foreach pkg,$(dependencies),$(MKPKGS_DIR)/$(call get-name,$(pkg))/$(call get-version,$(pkg))/$(main))

.ONESHELL:

# .mkpkgs/docker/1.0.0/

$(_include): private pkg = $(subst $(MKPKGS_DIR)/, ,$(dir $@))
$(_include):
	mkdir -p $(@D)
	cd $(@D)
	curl -sLO https://github.com/codextremist/$(call get-name,$(pkg))/archive/refs/tags/v$(call get-version,$(pkg)).tar.gz && tar -xvf v$(call get-version,$(pkg)).tar.gz -C $(MKPKGS_DIR)/$(call get-version,$(pkg)) --strip-components=1

mkpm-publish:
	git tag v$(version)
	git push -f origin v$(version)