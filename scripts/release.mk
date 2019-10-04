# 
# Makefile module to increment and tag version numbers 
# as preparation for release
# 
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

REPO ?= $(shell git rev-parse --show-toplevel)

RELEASE_SCRIPTS_DIR ?= $(realpath scripts)

.PHONY: _release_default _release-get-version release-inc-major-version release-inc-minor-version release-inc-patch-version release-commit-version _release-publish-latest
_release_default:
	$(error Please select a specific target)

_release-get-version:
	@$(RELEASE_SCRIPTS_DIR)/get-service-version.sh $(REPO)

release-inc-major-version:
	$(RELEASE_SCRIPTS_DIR)/inc-service-version.sh $(REPO) --major
release-inc-minor-version:
	$(RELEASE_SCRIPTS_DIR)/inc-service-version.sh $(REPO) --minor
release-inc-patch-version:
	$(RELEASE_SCRIPTS_DIR)/inc-service-version.sh $(REPO) --patch

release-commit-version:
	@$(RELEASE_SCRIPTS_DIR)/commit-tag-version.sh $(REPO)

# tag and push (mainly for set-idea-multi)
.PHONY: release-major-version release-minor-version release-patch-version
release-major-version: release-inc-major-version release-commit-version
release-minor-version: release-inc-minor-version release-commit-version
release-patch-version: release-inc-patch-version release-commit-version
