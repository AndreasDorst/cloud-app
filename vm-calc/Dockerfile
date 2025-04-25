FROM ruby:3.2.4-alpine3.18

ENV SRC_PATH /app
WORKDIR $SRC_PATH

COPY ./Gemfile* $SRC_PATH/
RUN bundle install

COPY . .

# Директива EXPOSE информирует о том, какой порт будет прослушивать приложение внутри контейнера.
# При этом, если необходимо обратиться к контейнеру извне, пробросить порты (параметр -p, --publish в docker run) всё равно нужно.
EXPOSE 5678

CMD ["ruby", "main.rb"]
