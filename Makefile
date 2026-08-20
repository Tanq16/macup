.PHONY: help build app zip clean version

APP_NAME := macup

VERSION ?= 0.0.0
# Release tags carry a leading v, which CFBundleShortVersionString rejects.
PLIST_VERSION := $(patsubst v%,%,$(VERSION))

CYAN  := \033[0;36m
GREEN := \033[0;32m
NC    := \033[0m

help: ## Show this help
	@echo "$(CYAN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

build: ## Compile the release binary
	swift build -c release

app: build ## Assemble and ad-hoc sign macup.app
	@rm -rf $(APP_NAME).app
	@mkdir -p $(APP_NAME).app/Contents/MacOS
	@cp .build/release/$(APP_NAME) $(APP_NAME).app/Contents/MacOS/$(APP_NAME)
	@cp Info.plist $(APP_NAME).app/Contents/Info.plist
	@/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $(PLIST_VERSION)" $(APP_NAME).app/Contents/Info.plist
	@/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $(PLIST_VERSION)" $(APP_NAME).app/Contents/Info.plist
	codesign --force --sign - $(APP_NAME).app

# ditto rather than zip, which drops the symlinks and metadata a bundle needs.
zip: app ## Package the app as macup.zip
	@rm -f $(APP_NAME).zip
	ditto -c -k --keepParent $(APP_NAME).app $(APP_NAME).zip

clean: ## Remove build output
	rm -rf .build $(APP_NAME).app $(APP_NAME).zip

version: ## Print the next version, derived from the last commit message
	@LATEST_TAG=$$(git tag --sort=-v:refname | head -n1 || echo "0.0.0"); \
	LATEST_TAG=$${LATEST_TAG#v}; \
	MAJOR=$$(echo "$$LATEST_TAG" | cut -d. -f1); \
	MINOR=$$(echo "$$LATEST_TAG" | cut -d. -f2); \
	PATCH=$$(echo "$$LATEST_TAG" | cut -d. -f3); \
	MAJOR=$${MAJOR:-0}; MINOR=$${MINOR:-0}; PATCH=$${PATCH:-0}; \
	COMMIT_MSG="$$(git log -1 --pretty=%B)"; \
	if echo "$$COMMIT_MSG" | grep -q "\[major-release\]"; then \
		MAJOR=$$((MAJOR + 1)); MINOR=0; PATCH=0; \
	elif echo "$$COMMIT_MSG" | grep -q "\[minor-release\]"; then \
		MINOR=$$((MINOR + 1)); PATCH=0; \
	else \
		PATCH=$$((PATCH + 1)); \
	fi; \
	echo "v$${MAJOR}.$${MINOR}.$${PATCH}"
