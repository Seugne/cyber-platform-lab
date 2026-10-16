FROM python:3.13-slim

WORKDIR /app

# Apply all currently available Debian security updates.
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install runtime dependencies, then remove build/package-management tooling
# that is not required by the running application.
RUN python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && python -m pip uninstall -y pip setuptools \
    && rm -rf /root/.cache/pip

COPY app ./app

RUN useradd --create-home --uid 10001 cloudguard

USER cloudguard

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "app.app:app"]
