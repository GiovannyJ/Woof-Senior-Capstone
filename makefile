GOCMD=go
GOBUILD=$(GOCMD) build
BINARY_NAME_API_WINDOWS=api.exe
BINARY_NAME_API_UNIX=api
API_DIR=API
BUILD_DIR=build

# Determine the operating system
ifeq ($(OS), Windows_NT)
    BINARY_NAME_API=$(BINARY_NAME_API_WINDOWS)
    COPY_COMMAND=copy $(API_DIR)\.env $(CURDIR)\$(BUILD_DIR) && copy $(API_DIR)\.env $(CURDIR)\$(BUILD_DIR)\.env
    RUN_COMMAND=./$(BINARY_NAME_API)
else
    BINARY_NAME_API=$(BINARY_NAME_API_UNIX)
    COPY_COMMAND=cp $(API_DIR)/.env $(CURDIR)/$(BUILD_DIR)/.env
    RUN_COMMAND=./$(BINARY_NAME_API)
endif

# build API exe
build_api: build

build:
	cd $(API_DIR)/ && $(GOBUILD) -o $(CURDIR)/$(BUILD_DIR)/$(BINARY_NAME_API) main.go
	$(COPY_COMMAND)

# Run API on port 8080 with .env
run:
	cd $(CURDIR)/$(BUILD_DIR)/ && $(RUN_COMMAND)


print_env:
	type $(API_DIR)/.env



#run 3rd Party API scripts
process:


#cleans build env
clean: