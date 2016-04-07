# Makefile to build and install the iRODS ruleset
#
#  
#  
#   make update    - download latest release from origin git repository
#   make install   - combine rules and copy it to the "/etc/irods" dir
#   make all       - builds the rules
#

# Input files.

RULE_FILES ?= $(wildcard *.r)

# Output files.

RULESET_NAME ?= ruleset-rit.re
RULESET_FILE := $(RULESET_NAME)

INSTALL_DIR  ?= /etc/irods

# Make targets.

all: $(RULESET_FILE)

$(RULESET_FILE): $(RULE_FILES)
	cat $(RULE_FILES) | sed '/^\s*\(#.*\)\?$$/d' | sed -E '/^(INPUT|OUTPUT).*/d' > $(RULESET_FILE)

install: $(RULESET_FILE)
	cp --backup $(RULESET_FILE) $(INSTALL_DIR)/$(RULESET_NAME)

clean:
	rm -f $(RULESET_FILE)

update:
	git pull