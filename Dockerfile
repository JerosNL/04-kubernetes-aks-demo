FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY tests/ ./tests/

RUN python -m pytest tests/ -v

CMD ["python", "-m", "py_compile", "src/calculator.py"]