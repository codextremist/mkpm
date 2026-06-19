### mkpm bootstrap
mkpm_pkg_dir := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifndef mkpm_included
ifndef MKPM_DIR
mkpm: 
	@curl https://raw.githubusercontent.com/codextremist/mkpm/refs/heads/master/Makefile > $@
else
mkpm: $(MKPM_DIR)
	@ln -sfn $(MKPM_DIR)/Makefile $@
endif
include mkpm
endif

ifneq ($(filter-out $(mkpm_included_pkgs),$(mkpm_include_pkgs)),)
mkpm_included_pkgs := $(sort $(mkpm_included_pkgs) $(mkpm_include_pkgs))
include $(mkpm_include_pkgs)
endif

mkpm_bootstraped := true
### /mkpm bootstrap