# Base image
FROM python:3.11

# Install necessary dependencies for OpenCV and libGL
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libsm6 \
    libxext6 \
    libxrender1 \
    libglib2.0-0 \
    ffmpeg \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Create a symbolic link for libGL.so.1 in the system library path
RUN ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/local/lib/libGL.so.1

# Set library path for OpenCV
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Work directory
WORKDIR /app

# Copy requirements file
COPY ./requirements.txt .
COPY ./requirements-all.txt .

# Install dependencies
RUN pip install --requirement requirements.txt --requirement requirements-all.txt

# Copy sources
COPY src src



# Environment variables
ENV ENVIRONMENT=${ENVIRONMENT}
ENV LOG_LEVEL=${LOG_LEVEL}
ENV ENGINE_URL=${ENGINE_URL}
ENV MAX_TASKS=${MAX_TASKS}
ENV ENGINE_ANNOUNCE_RETRIES=${ENGINE_ANNOUNCE_RETRIES}
ENV ENGINE_ANNOUNCE_RETRY_DELAY=${ENGINE_ANNOUNCE_RETRY_DELAY}

# Exposed ports
EXPOSE 80

# Switch to src directory
WORKDIR "/app/src"

# Command to run on start
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]