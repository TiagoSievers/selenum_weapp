# Set the base image to use cypress/browsers
FROM cypress/browsers:latest as cypress_base

# Set the base image for the final build
FROM python:3.8-slim

# Copy necessary files from the cypress_base image if needed (e.g., browsers)
COPY --from=cypress_base /usr/local/bin /usr/local/bin
COPY --from=cypress_base /usr/local/lib /usr/local/lib

# Set the working directory
WORKDIR /app

# Copy requirements.txt file to the working directory
COPY requirements.txt .

# Set the environment variable for the path
ENV PATH /home/root/.local/bin:${PATH}

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y python3-pip

# Install the Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the working directory
COPY . .

# Set the default port to 443 if not provided
ENV PORT 443

# Expose the port
EXPOSE ${PORT}

# Run the application
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT}
