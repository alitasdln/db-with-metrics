# Use a base image with Go installed
FROM golang:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the source code from your host to the container
COPY . .

# Build the Go application
RUN go build -o main ./main.go

# Expose the port that your Go application listens on
EXPOSE 5555

# Command to run your Go application
CMD ["./main"]
