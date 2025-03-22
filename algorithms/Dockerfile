# Use Python base image
FROM python:3.11.5

# Set the working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application files
COPY . .

# Expose gRPC server port
EXPOSE 8080

# Run the gRPC server
CMD ["python", "server.py"]