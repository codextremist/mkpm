mkpm_pkg_dir := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
include $(mkpm_pkg_dir)/mkpkg

ifndef mkpm_common_included
ifndef MKPM_DIR
.mkpm-common: 
	@curl -sL https://raw.githubusercontent.com/codextremist/mkpm/refs/heads/master/common > $@
else
.mkpm-common: $(MKPM_DIR)
	@ln -sfn $(MKPM_DIR)/common $@
endif
include .mkpm-common
endif

$(foreach pkg,$(mkpm_pkg_dependencies),$(eval mkpm_pkg__$(call get-pkg-name,$(pkg))=$(call get-pkg-scheme,$(pkg))))
$(foreach pkg,$(mkpm_pkg_dependencies),$(eval mkpm_pkg__$(call get-pkg-name,$(pkg))=$(call get-pkg-uri,$(pkg))))
$(foreach pkg,$(mkpm_pkg_dependencies),$(eval mkpm_pkg__$(call get-pkg-name,$(pkg))=$(call get-pkg-version,$(pkg))))

ifneq ($(filter-out $(mkpm_included_pkgs),$(mkpm_include_pkgs)),)
mkpm_included_pkgs := $(sort $(mkpm_included_pkgs) $(mkpm_include_pkgs))
include $(mkpm_include_pkgs)
endif

#mkpm_bootstrap := true