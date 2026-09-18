#!/bin/sh
# Проставляет версию, дату сборки и коммит в <meta name="build:*"> обеих языковых версий.
# Значения берутся из переменных окружения, иначе — из git, иначе — дефолты.
#
#   APP_VERSION=1.2.0 sh scripts/stamp-build.sh          # обе версии сайта
#   sh scripts/stamp-build.sh index.html                 # только указанные файлы
set -eu

VERSION="${APP_VERSION:-$(git describe --tags --always --dirty 2>/dev/null || echo dev)}"
BUILD_DATE="${BUILD_DATE:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"
COMMIT="${GIT_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo '')}"

FILES="${*:-index.html en/index.html}"

for f in $FILES; do
  [ -f "$f" ] || { echo "stamp-build: нет файла $f" >&2; exit 1; }
  # -i.bak + rm — чтобы работало и с BSD sed (macOS), и с GNU sed (CI, alpine)
  sed -i.bak \
    -e "s|<meta name=\"build:version\" content=\"[^\"]*\">|<meta name=\"build:version\" content=\"${VERSION}\">|" \
    -e "s|<meta name=\"build:date\" content=\"[^\"]*\">|<meta name=\"build:date\" content=\"${BUILD_DATE}\">|" \
    -e "s|<meta name=\"build:commit\" content=\"[^\"]*\">|<meta name=\"build:commit\" content=\"${COMMIT}\">|" \
    "$f"
  rm -f "$f.bak"
  echo "stamp-build: $f → ${VERSION} · ${BUILD_DATE}${COMMIT:+ · ${COMMIT}}"
done
