#-----------ESTADISTICAS DOCKERFILE-----------
# ---------- ETAPA 1: builder ----------
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt
 
# ---------- ETAPA 2: runtime ----------
FROM python:3.12-slim AS runtime
WORKDIR /app
RUN useradd -m appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY . .
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 8006
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8006"]
