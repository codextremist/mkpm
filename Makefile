mkpm_version := 1.0.0

QUIET ?= @

define newline


endef

define get-pkg-scheme
$(if $(findstring ://,$(1)),$(firstword $(subst ://, ,$(1)))://,https://)
endef

define get-pkg-version
$(if $(findstring =,$(1)),$(lastword $(subst =, ,$(1))),latest)
endef

define get-pkg-name
$(lastword $(subst /, ,$(subst @,/,$(if $(findstring =,$(1)),$(firstword $(subst =, ,$(1))),$(1)))))
endef

define get-pkg-uri
$(strip $(if $(findstring file://,$(1)),$(patsubst file://%,%,$(if $(findstring =,$(1)),$(firstword $(subst =, ,$(1))),$(1))),$(if $(findstring ://,$(1)),$(patsubst %/$(call get-pkg-name,$(1)),%,$(if $(findstring =,$(1)),$(firstword $(subst =, ,$(1))),$(1))),$(if $(findstring @,$(1)),https://github.com/$(firstword $(subst @, ,$(1))),https://github.com/codextremist))))
endef

define get-pkg-name-from-dir
$(firstword $(subst @, ,$(lastword $(subst /, ,$(dir $(1))))))
endef

mkpm_pkg_main ?= Makefile
mkpm_pkgs_dir ?= .mkpkgs

mkpm_include_pkgs = $(foreach pkg,$(mkpm_pkg_dependencies),$(mkpm_pkgs_dir)/$(call get-pkg-name,$(pkg))@$(call get-pkg-version,$(pkg))/$(mkpm_pkg_main))

.ONESHELL:

define link-pkg 
$(QUIET) ln -sfn $(mkpm_pkg__$(1)_uri)/* $(2)
endef

define download-pkg
$(QUIET)cd $(dir $1)
$(QUIET)curl -sLO https://github.com/codextremist/$(call get-name,$1)/archive/refs/tags/v$(call get-version,$1).tar.gz && tar -xvf v$(call get-version,$1).tar.gz -C ./ --strip-components=1
$(QUIET)rm v$(call get-version,$1).tar.gz
endef

# mkpkgs/mkpm-help@1.0.0/Makefile
$(mkpm_pkgs_dir)/%: | mkpkg
	$(QUIET)mkdir -p $(@D)
	$(if $(filter file://,$(mkpm_pkg__$(call get-pkg-name-from-dir,$@)_scheme)),$(call link-pkg,$(call get-pkg-name-from-dir,$@),$(@D)),$(call download-pkg,$(call get-pkg-name-from-dir,$@),$(@D)))

mkpm-remove-packages: ## Remove all mkpm packages
	rm -rf $(mkpm_pkgs_dir)

mkpm_included := true