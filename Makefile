# Update the dependency
dep:
	@go mod tidy

# Build the binary
build:
	@go build -o ./bin/main main.go

# Run the binary
run:
	make build
	@./bin/main

# Test the unitest
test:
	@bash ./scripts/code-coverage-go.sh

# Test the unitest for specific target
# required: BASE_BRANCH args
test-target:
	@bash ./scripts/code-coverage-go-target.sh $(BASE_BRANCH)