# Start from a python base image (lie choosing which ubuntu ISO to use)
FROM python:3.11-slim

# Set the working directory in container
WORKDIR /app

# copy our script to conatainer
COPY hello.py .

# The command that runs when the conatainer start
CMD ["python3", "hello.py"]
