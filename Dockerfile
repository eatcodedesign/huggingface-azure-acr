# 1. Switched to a lightweight, modern base image
FROM python:3.10-slim

# 2. Perfect caching sequence retained
COPY ./requirements.txt /webapp/requirements.txt
WORKDIR /webapp
RUN pip install --no-cache-dir -r requirements.txt

# 3. Import application code
COPY webapp/* /webapp

# 4. Bake the model weights directly into the container image
RUN python -c "from transformers import AutoTokenizer, TFGPT2LMHeadModel; AutoTokenizer.from_pretrained('gpt2'); TFGPT2LMHeadModel.from_pretrained('gpt2')"

EXPOSE 8000

ENTRYPOINT [ "uvicorn" ]
CMD [ "--host", "0.0.0.0", "main:app" ]
