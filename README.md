# nazook-pin

Лендинг про значок «Назук» — саратовский пароль. Две языковые версии на общих стилях.

- RU: https://kvendingoldo.github.io/nazook-pin/
- EN: https://kvendingoldo.github.io/nazook-pin/en/

## Структура

```
index.html          русская версия
en/index.html       английская версия
styles.css          дизайн-система: токены, компоненты, брейкпоинты
assets/             графика значка, портреты авторов, иконки, превью для соцсетей
robots.txt          индексация разрешена, черновики закрыты, ссылка на sitemap
sitemap.xml         обе версии с hreflang-альтернативами
drafts/             ранние варианты оформления: noindex, из поиска исключены
scripts/stamp-build.sh        проставляет версию и дату сборки в HTML
Dockerfile                    образ с nginx, стартует тот же статический сайт
.github/workflows/pages.yml   автодеплой при пуше в main
```

## Как править

**Стили** — только в `styles.css`, значения берутся из токенов в `:root`
(`--space-*`, `--text-*`, `--surface-*`, `--accent*`). Новые хардкод-цвета
и отступы добавлять не нужно.

**Тексты** — в `index.html` и `en/index.html`; правку в одной версии переносить
во вторую.

**Графика моста** — инлайновый SVG в обоих файлах, покрашен токенами
(`--bridge-arch`, `--bridge-truss`, `--bridge-pier`, `--water`, `--lamp`).
Разметка моста в RU и EN должна оставаться идентичной.

**Портреты** — квадратные JPEG 256×256 в `assets/`, кадрируются по кругу:

```sh
sips -c 1100 1100 --cropOffset <top> <left> исходник.jpg --out /tmp/sq.jpg
sips -Z 256 -s formatOptions 82 /tmp/sq.jpg --out assets/имя.jpg
```

**Превью для соцсетей** (`assets/og-cover.png`, 1200×630) собирается из первого
экрана — если он заметно изменится, пересними:

Переключатель языка в превью не нужен, поэтому снимаем не сам `index.html`,
а его временную копию, где `.lang` скрыт (`visibility` — чтобы вёрстка первого
экрана не поехала):

```sh
sed 's|</head>|<style>.lang{visibility:hidden}</style></head>|' \
  index.html > .og-shot.tmp.html
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless \
  --window-size=1200,630 --screenshot=assets/og-cover.png "file://$PWD/.og-shot.tmp.html"
rm .og-shot.tmp.html
```

## Версия и дата сборки

Обе версии сайта печатают в консоль браузера версию, дату сборки и коммит —
их же можно прочитать из `window.nazook.build`:

```
Значок «Назук»  1.0.0
Сборка: 2026-09-18T13:24:00Z · коммит 0be6b74
```

Значения живут в `<meta name="build:version|date|commit">` и по умолчанию пустые
(в консоли — `dev` и «локальная, дата не проставлена»). Проставляет их
`scripts/stamp-build.sh`, прямо в HTML:

```sh
APP_VERSION=1.0.0 sh scripts/stamp-build.sh    # обе версии сайта
sh scripts/stamp-build.sh index.html           # только указанные файлы
```

Без переменных версия и коммит берутся из git (`git describe --tags --always`,
`git rev-parse --short HEAD`), дата — текущий UTC. Скрипт правит файлы на месте,
поэтому в репозитории меты остаются пустыми: штампует их сборка, а не коммит.

В CI (`pages.yml`) шаг выполняется перед загрузкой артефакта, версия —
`build-<номер запуска>`.

## Docker

```sh
docker build -t nazook-pin \
  --build-arg APP_VERSION="$(git describe --tags --always)" \
  --build-arg GIT_SHA="$(git rev-parse --short HEAD)" \
  --build-arg BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)" .

docker run --rm -p 8080:80 nazook-pin   # http://localhost:8080
```

Сборка двухстадийная: alpine штампует версию тем же `stamp-build.sh`, nginx
раздаёт результат. Те же значения уходят в OCI-лейблы
(`org.opencontainers.image.version|created|revision`). Все три аргумента
необязательны — без них будет `dev`, дата в HTML проставится временем сборки.

## Локальный просмотр

Ссылки языкового переключателя ведут на «чистые» адреса (`/en/`), поэтому
смотреть лучше через сервер:

```sh
python3 -m http.server 8000   # http://localhost:8000
```

## При смене адреса сайта

Абсолютные URL прописаны в `canonical`, `hreflang`, Open Graph и JSON-LD обоих
HTML, а также в `robots.txt` и `sitemap.xml` — менять во всех местах.

## GitHub Pages

Settings → Pages → Source: **GitHub Actions**. Каждый пуш в `main` деплоит сайт.
