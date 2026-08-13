# nazook-pin

Небольшой одностраничный лендинг про значок «Назук» — опознавательный знак саратовцев.

Сайт: https://kvendingoldo.github.io/nazook-pin/

## Структура

```
index.html                   вся страница (HTML + CSS + пара строк JS, без зависимостей)
assets/nazuk.png             иллюстрация значка
.github/workflows/pages.yml  автодеплой на GitHub Pages при пуше в main
.nojekyll                    отключает обработку Jekyll
```

Мост через Волгу нарисован инлайновым SVG прямо в `index.html` (блок `.bridge`).

## Что осталось заменить

Помечено в `index.html` комментарием `TODO`:

1. **История** — секция `#story`, текст сейчас черновой.
2. **Авторы** — секция `#authors`: три карточки (1 × дизайн, 2 × идея).
   В каждой заменить имя и ссылки `https://instagram.com/USERNAME`, `https://t.me/USERNAME`.
   Лишние ссылки можно просто удалить.

## Локальный просмотр

```sh
open index.html
# или
python3 -m http.server 8000   # http://localhost:8000
```

## Включить GitHub Pages

Settings → Pages → Source: **GitHub Actions**. Дальше каждый пуш в `main` деплоит сайт.
