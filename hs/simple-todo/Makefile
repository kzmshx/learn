MAIN := Main.hs

.DEFAULT_GOAL := help
.PHONY: help
help:	## Display help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: run
run:	## Run the project
	@stack runghc $(MAIN)

.PHONY: install-fmt
install-fmt:
	@stack install ormolu

.PHONY: fmt
fmt:	## Format the project
	@ormolu --mode inplace $(shell find . -name '*.hs')
