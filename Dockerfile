# Use Python base image
FROM python:3.9

# Set working directory in the container
WORKDIR /app

# Copy the Flask app file to the container
COPY flask-app.py /app

# Install Flask and dependencies
RUN pip install flask pymongo

# Expose the Flask app port
EXPOSE 4444

# Define the command to run the Flask app
CMD ["python", "flask-app.py"]
