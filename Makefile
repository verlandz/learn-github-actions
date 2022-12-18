# Update the dependency
dep:
	@go mod tidy

# Test the unitest
test:
	@bash ./scripts/code-coverage-go.sh

# Test the unitest for specific target
# ex: make test-target BASE_BRANCH=main
test-target:
	@bash ./scripts/code-coverage-go-target.sh $(BASE_BRANCH)