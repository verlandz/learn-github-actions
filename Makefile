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
	@bash ./scripts/coverage.sh