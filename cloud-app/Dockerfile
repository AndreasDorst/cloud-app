FROM ruby:3.2.4-alpine3.18

# установка библиотек для работы приложения (сейчас отсутствуют)
RUN apk add --update --no-cache build-base git vips libpq-dev sqlite-libs tzdata less

# Создаем пользователя приложения (безопасность)
ARG UID=1000
ARG GID=1000
RUN addgroup -g $GID -S appuser && \
    adduser -u $UID -S -G appuser appuser

ENV APP_PATH=/usr/src
WORKDIR $APP_PATH

# устаналиваем гемы, необходимые приложению
COPY Gemfile* $APP_PATH/
RUN bundle install -j4

# копируем код приложения
COPY . .

# сообщаем другим разработчикам и devopsам о том, на каком порту работает наше приложение
EXPOSE 3000

# устанавливаем команду по умолчанию
CMD ["rails", "server", "-b", "0.0.0.0"]
