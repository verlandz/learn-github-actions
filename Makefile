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
	@bash ./scripts/go-coverage.sh

# Test the unitest for specific target
test-target:
	@bash ./scripts/code-coverage-go-target.sh