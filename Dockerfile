FROM squidfunk/mkdocs-material:latest
WORKDIR /workspace
EXPOSE 8000

FROM python:3.12-slim-trixie
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/