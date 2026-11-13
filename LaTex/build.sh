#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

IMAGE="${TEXLIVE_IMAGE:-texlive/texlive:latest}"
ACTION="${1:-pdf}"

case "$ACTION" in
  pdf)
    LATEXMK_ARGS=(-xelatex -synctex=1 -interaction=nonstopmode -file-line-error main.tex)
    ;;
  watch)
    LATEXMK_ARGS=(-xelatex -synctex=1 -interaction=nonstopmode -file-line-error -pvc main.tex)
    ;;
  clean)
    LATEXMK_ARGS=(-c main.tex)
    ;;
  distclean)
    LATEXMK_ARGS=(-C main.tex)
    ;;
  *)
    printf 'Uso: %s [pdf|watch|clean|distclean]\n' "$0" >&2
    exit 1
    ;;
esac

if ! docker info >/dev/null 2>&1; then
  printf 'Error: Docker no está disponible. Arranca Docker y vuelve a intentarlo.\n' >&2
  exit 1
fi

exec docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -e TEXMFVAR=/tmp/texmf-var \
  -e TEXMFCACHE=/tmp/texmf-cache \
  -v "$PWD:$PWD" \
  -w "$PWD" \
  "$IMAGE" \
  latexmk "${LATEXMK_ARGS[@]}"
