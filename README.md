# nazook-pin

Лендинг про значок «Назук» — саратовский пароль. Две языковые версии на общем CSS.

- RU: https://kvendingoldo.github.io/nazook-pin/
- EN: https://kvendingoldo.github.io/nazook-pin/en/

## Структура

```
index.html          русская версия
en/index.html       английская версия
styles.css          дизайн-система: токены, компоненты, брейкпоинты
assets/             иллюстрация значка и фото авторов
robots.txt          индексация разрешена, ссылка на sitemap
sitemap.xml         обе версии + hreflang-альтернативы
.nojekyll           отключает обработку Jekyll
.github/workflows/pages.yml   автодеплой при пуше в main
```

## Как править

**Стили** — только в `styles.css`. Значения берутся из токенов в `:root`
(`--space-*`, `--text-*`, `--radius-*`, `--surface-*`, `--accent*`), новые
хардкод-цвета и отступы добавлять не нужно.

**Тексты** — в двух файлах: `index.html` и `en/index.html`. Правки в одной
версии не забывать переносить во вторую.

**Языковой переключатель** — блок `.topbar` в начале `<section class="hero">`
в обоих файлах.

**Фото авторов** — квадратные JPEG в `assets/`, 600×600, кадрируются по кругу.
Подготовить новое:

```sh
sips -c 1100 1100 --cropOffset <top> <left> исходник.jpg --out /tmp/sq.jpg
sips -Z 600 -s formatOptions 82 /tmp/sq.jpg --out assets/имя.jpg
```

## Локальный просмотр

```sh
open index.html
# или как на проде, с чистыми URL:
python3 -m http.server 8000   # http://localhost:8000
```

## При смене адреса сайта

Абсолютные URL прописаны в `canonical`, `hreflang`, Open Graph и JSON-LD
обоих HTML, а также в `robots.txt` и `sitemap.xml` — менять во всех местах.

## Включить GitHub Pages

Settings → Pages → Source: **GitHub Actions**. Дальше каждый пуш в `main`
деплоит сайт.
