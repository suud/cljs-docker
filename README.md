# cljs

## Quickstart
```sh
docker run -it --rm -p 127.0.0.1:80:3000 -p 127.0.0.1:9630:9630 -v "$(pwd)":/usr/src/app -w /usr/src/app suud/cljs bash
lein new reagent hello-world --to-dir $PWD +shadow-cljs
npm install reagent reagent-dom
shadow-cljs watch app
```

## Prerequisites
### Setup new cljs project

```sh
# create lein project based on reagent template, compatible with shadow-cljs
lein new reagent hello-world +shadow-cljs
```
[more flags](https://github.com/reagent-project/reagent-template#usage)

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
    - 127.0.0.1:80:3000
    # shadow-cljs http and websocket
    - 127.0.0.1:9630:9630
#    # nrepl
#    - 127.0.0.1:9000:9000
```

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
    - you might use that to create a production build

## Build for Production

Build a release that is optimized for production use:
```sh
shadow-cljs release app
```
When no `:output-dir` is configured in the `shadow-cljs.edn`, the build will be
saved under `public/js`.

# Become my caffeine sponsor
<a href="https://www.buymeacoffee.com/suud" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-orange.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;" ></a>

# License
This repository is released under the
[MIT License](https://opensource.org/licenses/MIT).
