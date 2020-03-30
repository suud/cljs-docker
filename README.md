# cljs

## Quickstart
```sh
# re-frame
docker run -it --rm -p 127.0.0.1:80:8280 -p 127.0.0.1:9630:9630 -v "$(pwd)":/usr/src/app -w /usr/src/app suud/cljs bash
lein new re-frame hello-world --to-dir "$(pwd)" --force -- +10x
# Alternative: Reagent
# docker run -it --rm -p 127.0.0.1:80:3000 -p 127.0.0.1:9630:9630 -v "$(pwd)":/usr/src/app -w /usr/src/app suud/cljs bash
# lein new reagent hello-world --to-dir "$(pwd)" --force -- +shadow-cljs

lein deps
npm install
#lein sassc once # build css
shadow-cljs watch app
```

To see other available `shadow-cljs` commands run:
```sh
shadow-cljs --help
```
or browse the [Shadow CLJS User Guide](https://shadow-cljs.github.io/docs/UsersGuide.html).

## Prerequisites
### Setup new cljs project

```sh
# create lein project based on re-frame template
lein new re-frame hello-world
# you can use optional profiles:
# lein new re-frame hello-world +10x +routes
```
[optional profiles](https://github.com/day8/re-frame-template#extras)


You might want to use the [Reagent Template](https://github.com/reagent-project/reagent-template#usage), instead.
Keep in mind that Reagent uses `3000` as default port for it's webserver while re-frame uses `8280`.
`+shadow-cljs` is required when using Reagent.

### Create `Dockerfile`
```yaml
FROM suud/cljs

## nrepl port (has to be configured in shadow-cljs.edn)
## see: https://shadow-cljs.github.io/docs/UsersGuide.html#nREPL
#EXPOSE 9000


WORKDIR /usr/src/app

COPY package.json .
RUN npm install

ADD . .

CMD shadow-cljs watch app
```

### Create `docker-compose.yml`
```yaml
app:
  build: .
  volumes:
    - .:/usr/src/app
  ports:
    # web server
    - 127.0.0.1:80:8280
    # shadow-cljs http and websocket
    - 127.0.0.1:9630:9630
#    # nrepl
#    - 127.0.0.1:9000:9000
```

### (optional) Add Sass support
Create a `sass/mystyles.scss` file that contains your custom styles.

In the `project.clj` file, add the following:
```
    :plugins [...
              [lein-sassc "0.10.5"]]

    :sassc [{:src         "sass/mystyles.scss"
             :output-to   "resources/public/css/mystyles.css"
             :style       "nested"
             :import-path "sass"}]
```

Inside the `<head>` of `resources/public/index.html` add the following:
```
<link rel="stylesheet" href="css/mystyles.css">
```

You will need to manually run `lein sassc once` to rebuild your CSS file
when you have changes.

## Development Workflow
- deploy application: `docker-compose up -d`
    - application HTTP server: `http://localhost:80`
    - shadow-cljs dashboard: `http://localhost:9630`
    - logs: `docker-compose logs -f app`
- Do your changes inside the project directory. This should be done
from the host system. You might loose your changes if you modify files inside
the container and a directory isn't mounted correctly.
- A temporary second instance of a service's container can be started and
attached to with `docker-compose run --rm app bash`
    - you might use that to create a production build or build custom css files

## Build for Production

Build a release that is optimized for production use:
```sh
lein clean
shadow-cljs release app
```
When no `:output-dir` is configured in the `shadow-cljs.edn`, the build will be
saved under `public/js`.

# Become my caffeine sponsor
<a href="https://www.buymeacoffee.com/suud" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-orange.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;" ></a>

# License
This repository is released under the
[MIT License](https://opensource.org/licenses/MIT).
