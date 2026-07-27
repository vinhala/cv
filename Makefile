# LaTeX Docker environment configuration
DOCKER_IMAGE = texlive/texlive:latest
SOURCE_DIR = cv_vincent
OUTPUT_DIR = output

# Main targets
.PHONY: all clean pdf pdf-en pdf-de docker-build docker-run

all: pdf

# Build both resume PDFs from LaTeX source
pdf: pdf-en pdf-de

# Build English resume PDF
pdf-en: TEX_FILE = resume_cv

# Build German resume PDF
pdf-de: TEX_FILE = resume_cv_de

pdf-en pdf-de: docker-build
	mkdir -p $(OUTPUT_DIR)
	docker run --rm -v $(PWD):/workspace \
		-w /workspace \
		$(DOCKER_IMAGE) \
		bash -c "cd $(SOURCE_DIR) && \
		xelatex -output-directory=/workspace/$(OUTPUT_DIR) $(TEX_FILE).tex && \
		xelatex -output-directory=/workspace/$(OUTPUT_DIR) $(TEX_FILE).tex"

# Build Docker image if needed
docker-build:
	@docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || docker pull $(DOCKER_IMAGE)

# Clean generated files
clean:
	rm -rf $(OUTPUT_DIR)

# Run interactive shell in Docker container
docker-run:
	docker run --rm -it -v $(PWD):/workspace \
		-w /workspace/$(SOURCE_DIR) \
		$(DOCKER_IMAGE) /bin/bash
