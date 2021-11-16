FROM python:3.9-slim as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y gcc libffi-dev g++
WORKDIR /app

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.11

RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./
RUN . /venv/bin/activate && poetry install --no-dev --no-root

COPY . .
RUN . /venv/bin/activate && poetry build

FROM base as final

COPY --from=builder /venv /venv
COPY --from=builder /app/dist .
COPY entrypoint.sh ./

RUN . /venv/bin/activate && /venv/bin/python -m pip install --upgrade pip && pip install *.whl && pip install gunicorn
RUN chmod +x entrypoint.sh
CMD ["./entrypoint.sh"]
#CMD ["gunicorn", \
#     "--bind", "0.0.0.0:5000", \
#     "guesslang_http:app"]
