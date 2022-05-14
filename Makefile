SRC = amti/
VENV ?= venv

export PIP_DISABLE_PIP_VERSION_CHECK=1

$(VENV): requirements.txt requirements_dev.txt
	@python -m venv $@ --prompt $@::amti
	@source $@/bin/activate && pip install -r $< -r requirements_dev.txt
	@echo "Enter virtual environment: source venv/bin/activate"

.PHONY: install
install: requirements.txt $(SRC)
	@pip install --user --require-hashes -r $<
	@pip install --user --no-deps .

.PHONY: install_dev
install_dev: venv
	@source $(VENV)/bin/activate && pip install -e .[dev]

build: $(SRC)
	@python -m build

tags: $(SRC)
	@ctags --languages=python --python-kinds=-i -R $(SRC)

.PHONY: outdated
outdated:
	@source $(VENV)/bin/activate && pip list --outdated

.PHONY: lint
lint:
	@pylint -f colorized $(SRC)

.PHONY: typecheck
typecheck:
	@mypy $(SRC)
