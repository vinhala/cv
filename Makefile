# LaTeX Docker environment configuration
DOCKER_IMAGE = texlive/texlive:latest
SOURCE_DIR = cv_vincent
OUTPUT_DIR = output

# Main targets
.PHONY: all clean pdf docker-build docker-run

all: pdf

# Build PDF from LaTeX source
pdf: docker-build
	mkdir -p $(OUTPUT_DIR)
	docker run --rm -v $(PWD):/workspace \
		-w /workspace \
		$(DOCKER_IMAGE) \
		bash -c "cd $(SOURCE_DIR) && \
		xelatex -output-directory=/workspace/$(OUTPUT_DIR) resume_cv.tex && \
		xelatex -output-directory=/workspace/$(OUTPUT_DIR) resume_cv.tex"

# Build Docker image if needed
docker-build:
	@docker pull $(DOCKER_IMAGE)

# Clean generated files
clean:
	rm -rf $(OUTPUT_DIR)

# Run interactive shell in Docker container
docker-run:
	docker run --rm -it -v $(PWD):/workspace \
		-w /workspace/$(SOURCE_DIR) \
		$(DOCKER_IMAGE) /bin/bash 