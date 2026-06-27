# Start with the lightweight base image
FROM python:3.10-slim

# Install system dependencies required by TensorFlow on slim images
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*


COPY ./requirements.txt /webapp/requirements.txt
WORKDIR /webapp
RUN pip install --no-cache-dir -r requirements.txt

# Import application code
COPY webapp/* /webapp

# Bake the model weights directly into the container image
RUN python -c "from transformers import AutoTokenizer, TFGPT2LMHeadModel; AutoTokenizer.from_pretrained('gpt2'); TFGPT2LMHeadModel.from_pretrained('gpt2')"

EXPOSE 8000

ENTRYPOINT [ "uvicorn" ]
CMD [ "--host", "0.0.0.0", "main:app" ]
