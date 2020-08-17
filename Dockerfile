FROM clojure

RUN apt-get update && apt-get install -qq \
    sassc curl && \
# install nodejs 14
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
# install shadow-cljs
    npm install -g shadow-cljs

# use this port in your shadow-cljs.edn (:dev-http {8080 "public"})
EXPOSE 8080
# shadow-cljs's default server and websocket port
EXPOSE 9630
