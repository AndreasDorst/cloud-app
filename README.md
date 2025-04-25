# Быстрый старт

## Проверка зависимостей:

### Git:

1.  Откройте терминал.
2.  Выполните команду `git --version`.
3.  Если Git установлен, вы увидите версию. Если нет, установите Git.

### Docker и Docker Compose:

1.  Выполните команды `docker --version` и `docker compose version`.
2.  Убедитесь, что обе программы установлены. Если нет, установите Docker и Docker Compose.

## Клонирование репозитория:

```
git clone https://git-intern.digitalleague.ru/ruby-intern-9/cloud-app.git
```

## Сборка Docker-образов:

```
docker compose build
```

## Запуск приложения:

```
docker compose up
```

При желании, при использовании команды `docker compose up` можно использовать флаг `-d`, чтобы запустить контейнеры в фоновом режиме.

### Примеры использования API

#### Базовая конфигурация VM
Откройте в браузере:
```
http://localhost:3000/orders/check?os=linux&cpu=2&ram=4&hdd_type=sata&hdd_capacity=100
```

#### VM с дополнительными дисками
Откройте в браузере:
```
http://localhost:3000/orders/check?os=linux&cpu=2&ram=4&hdd_type=ssd&hdd_capacity=100&volumes=[{"hdd_type":"sata","capacity":500},{"hdd_type":"ssd","capacity":250}]
```

Параметры запроса:
- os: операционная система
- cpu: количество ядер процессора
- ram: объем оперативной памяти в GB
- hdd_type: тип диска ("ssd" или "sata")
- hdd_capacity: размер основного диска в GB