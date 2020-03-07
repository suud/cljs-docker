FROM clojure

RUN apt-get update && apt-get install -qq \
    curl && \
# install nodejs 13
    curl -sL https://deb.nodesource.com/setup_13.x | bash - && \
	apt-get install -y nodejs && \
# install shadow-cljs
	npm install -g shadow-cljs

# default web server port
EXPOSE 3000
# shadow-cljs's default http and websocket port
EXPOSE 9630
