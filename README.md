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

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless \
  --window-size=1200,630 --screenshot=assets/og-cover.png "file://$PWD/index.html"
```

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
