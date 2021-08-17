NAME := nvim-lspservers
IMAGE_NAME := $(NAME)

TEST_DIR := ./tests
TESTS    ?= $(TEST_DIR)

build-image:
	@docker image build --force-rm --no-cache -t $(IMAGE_NAME) .

remove-image:
	@docker image rm -f $(IMAGE_NAME)

test:
	@docker container run --rm \
		-v $(PWD):/opt/$(NAME) \
		-w /opt/$(NAME) \
		$(IMAGE_NAME) \
		nvim --headless -u $(TEST_DIR)/minimal_init.vim \
			-c "PlenaryBustedDirectory $(TESTS) { minimal_init = '$(TEST_DIR)/minimal_init.vim' }" \
			-c q

test_server:
	@docker container run --rm \
		-v $(PWD):/opt/$(NAME) \
		-w /opt/$(NAME) \
		$(IMAGE_NAME) \
		./scripts/test_installer.sh $(SERVER)

test_all_servers:
	@docker container run --rm \
		-v $(PWD):/opt/$(NAME) \
		-w /opt/$(NAME) \
		$(IMAGE_NAME) \
		./scripts/test_all_installers.sh

run:
	@docker container run -it --rm \
		-v $(PWD):/opt/$(NAME) \
		-w /opt/$(NAME) \
		$(IMAGE_NAME) \
		nvim -u $(TEST_DIR)/minimal_init.vim
