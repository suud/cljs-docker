# [cljs development container](https://github.com/suud/cljs-docker/)
![Docker Automated build](https://img.shields.io/docker/automated/suud/cljs)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/suud/cljs)

## Quickstart
```sh
docker run -v "$(pwd)":/app -w /app \
           -it \
           --rm \
           -p 127.0.0.1:80:8080 \
           -p 127.0.0.1:9630:9630 \
           --name cljs \
           --hostname cljs \
           suud/cljs

# if you don't have an existing project, yet, create one as explained at
# https://github.com/thheller/shadow-cljs#quick-start

# TODO: build css files

shadow-cljs watch app
```

To see other available `shadow-cljs` commands run:
```sh
shadow-cljs --help
```
or browse the [Shadow CLJS User Guide](https://shadow-cljs.github.io/docs/UsersGuide.html).

## Prerequisites
### Setup new cljs project

Create a new `shadow-cljs` project.
You can use [this guide](https://github.com/thheller/shadow-cljs#quick-start).

### Create `Dockerfile`
```yaml
FROM suud/cljs

## nrepl port (has to be configured in shadow-cljs.edn)
## see: https://shadow-cljs.github.io/docs/UsersGuide.html#nREPL
#EXPOSE 9000


WORKDIR /app

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
    - .:/app
  ports:
    # web server
    - 127.0.0.1:80:8080
    # shadow-cljs http and websocket
    - 127.0.0.1:9630:9630
#    # nrepl
#    - 127.0.0.1:9000:9000
```

## Development Workflow
- deploy application: `docker-compose up -d`
    - application HTTP server: `http://localhost`
    - shadow-cljs dashboard: `http://localhost:9630`
    - logs: `docker-compose logs -f app`
- Do your changes inside the project directory. This should be done
from the host system. You might loose your changes if you modify files inside
the container and a directory isn't mounted correctly.
- A temporary second instance of a service's container can be started and attached to with `docker-compose run --rm app bash`
    - you might use that to build css files or connect a REPL


## Build for Production

Build a release that is optimized for production use:
```sh
# TODO: build css files
shadow-cljs release app
```
When no `:output-dir` is configured in the `shadow-cljs.edn`, the build will be
output to `public/js`.


# License
This repository is released under the
[MIT License](https://opensource.org/licenses/MIT).
