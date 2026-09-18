# syntax=docker/dockerfile:1
#
#   docker build -t nazook-pin \
#     --build-arg APP_VERSION="$(git describe --tags --always)" \
#     --build-arg GIT_SHA="$(git rev-parse --short HEAD)" \
#     --build-arg BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)" .
#   docker run --rm -p 8080:80 nazook-pin
#
# Все три аргумента необязательны: без APP_VERSION/GIT_SHA в консоль уйдёт «dev»,
# без BUILD_DATE дата в HTML проставится временем сборки образа (но OCI-лейбл
# org.opencontainers.image.created останется «unknown» — команда выше их синхронизирует).

FROM alpine:3.20 AS build

ARG APP_VERSION=dev
ARG BUILD_DATE
ARG GIT_SHA

WORKDIR /src
COPY index.html styles.css robots.txt sitemap.xml ./
COPY en ./en
COPY assets ./assets
COPY scripts ./scripts

RUN APP_VERSION="${APP_VERSION}" BUILD_DATE="${BUILD_DATE}" GIT_SHA="${GIT_SHA}" \
    sh scripts/stamp-build.sh

FROM nginx:1.27-alpine

ARG APP_VERSION=dev
ARG BUILD_DATE=unknown
ARG GIT_SHA=unknown

LABEL org.opencontainers.image.title="nazook-pin" \
      org.opencontainers.image.description="Лендинг про значок «Назук»" \
      org.opencontainers.image.source="https://github.com/kvendingoldo/nazook-pin" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${GIT_SHA}"

COPY --from=build /src/index.html /src/styles.css /src/robots.txt /src/sitemap.xml /usr/share/nginx/html/
COPY --from=build /src/en     /usr/share/nginx/html/en
COPY --from=build /src/assets /usr/share/nginx/html/assets
