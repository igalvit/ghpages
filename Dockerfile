FROM ruby:alpine

LABEL maintainer="igalvit@gmail.com"

ENV GHP_VERSION 203
ENV JK_VERSION 4.0.0

RUN apk --update add git \
   && apk --update add --virtual build_deps build-base ruby-dev libc-dev linux-headers
RUN gem install --no-document json jekyll-github-metadata \ 
   github-pages:${GHP_VERSION} minitest
RUN apk del build_deps \
 && rm -rf /usr/lib/ruby/gems/*/cache/*.gem \
  && addgroup appgroup && adduser appuser -G appgroup -D \
  && mkdir /_site \
  && chown -R appuser:appgroup /_site

WORKDIR /home/appuser
USER appuser

EXPOSE 4000 80

CMD bundle exec jekyll serve -d /_site --watch --force_polling -H 0.0.0.0 -P 4000
