FROM python:3.11-slim

WORKDIR /flask_app

COPY app.py /flask_app/
COPY models.py /flask_app/
COPY requirements.txt /flask_app/

RUN pip3 install --upgrade pip && pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8080", "-w", "4"]
