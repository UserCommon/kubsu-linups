# docker/Dockerfile
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_NO_CACHE_DIR=off

WORKDIR /app

# Устанавливаем системные зависимости
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

# Копируем файлы проекта
COPY pyproject.toml README.md ./
COPY src ./src

# Устанавливаем пакеты
RUN pip install --no-cache-dir --upgrade pip \
    && pip install ".[test]"  # при необходимости оставить просто "."

EXPOSE 8062  # замените на порт из кредитного листа

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8062"]
