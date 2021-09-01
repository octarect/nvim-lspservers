NAME := nvim-lspservers
IMAGE_NAME := ghcr.io/octarect/nvim-lspservers:latest
DOCKER_RUN := ./scripts/docker.sh

TEST_DIR := ./tests
TESTS    ?= $(TEST_DIR)

image:
	@docker image build -t $(IMAGE_NAME) .

test:
	$(DOCKER_RUN) nvim --headless -u $(TEST_DIR)/minimal_init.vim \
		-c "PlenaryBustedDirectory $(TESTS) { minimal_init = '$(TEST_DIR)/minimal_init.vim' }" \
		-c q

test-server:
	$(DOCKER_RUN) ./scripts/test_installer.sh $(SERVER)

test-all-servers:
	$(DOCKER_RUN) ./scripts/test_all_installers.sh

run:
	$(DOCKER_RUN) -it nvim -u $(TEST_DIR)/minimal_init.vim

style-lint:
	stylua --check .

.PHONY: image test test-server test-all-servers run style-lint
