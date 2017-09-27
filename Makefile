# Project configuration

NAME=developer-api-docs
VERSION=0.0.1
LOCAL_PORT=2022


# Running -----------------------------------------------------------------------------------

.PHONY: serve
serve:  ## Serve the documentation locally using mkdocs command
	@mkdocs serve --dev-addr=0.0.0.0:${LOCAL_PORT}

.PHONY: open
open:  ## Open locally-served documentation in browser
	@open http://127.0.0.1:${LOCAL_PORT}

#.PHONY: run
#run:  ## Serve the documentation locally and open it in browser
#	@mkdocs serve --dev-addr=0.0.0.0:${LOCAL_PORT} & open http://127.0.0.1:${LOCAL_PORT}


# Building -----------------------------------------------------------------------------------

.PHONY: build-site
build-site:  ## Build site
	@mkdocs build

.PHONY: clean-site
clean-site:  ## Clean site
	@mkdocs build  --clean


# GitHub Repository -----------------------------------------------------------------------------------

.PHONY: open-repo
open-repo:  ## Open URL of project GitHub repository page
	@open https://github.com/filethis/${NAME}

.PHONY: url-repo
url-repo:  ## Print URL of project GitHub repository page
	@echo https://github.com/filethis/${NAME}


# Application -----------------------------------------------------------------------------------

.PHONY: open-site
open-site:  ## Open the published documentation in browser
	@open https://filethis.github.io/${NAME}/

.PHONY: url-site
url-site:  ## Print URL of the published documentation
	@echo https://filethis.github.io/${NAME}/


# Release -----------------------------------------------------------------------------------

.PHONY: release
release:  ## Publish static files in GitHub Pages for this project
	@mkdocs gh-deploy


# Help -----------------------------------------------------------------------------------

.PHONY: help
help:  ## Print Makefile usage. See: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help