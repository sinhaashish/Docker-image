# Use the official Rust image as the base image
FROM rust:latest as builder

# Set the working directory to the location of the Rust project
WORKDIR /usr/src/server

# Copy the Cargo.toml and Cargo.lock files to the container
COPY Cargo.toml Cargo.lock ./

# Build the dependencies
#RUN mkdir src && echo "fn main() {}" > src/main.rscargo build --all

# Copy the source code to the container
COPY src ./src

# Build the Rust project
RUN cargo build --all

# RUN apt install libc6

# RUN apt-get update -y && apt upgrade -y  && \
#     apt-get install -y echo && \
#     apt install -y libc6 && \
#     apt-get install -y libssl-dev

# Start a new stage with a smaller base image
FROM debian:buster-slim

# Set the working directory to the location of the built binary
WORKDIR /usr/src/server

# Copy the built binary from the previous stage to this stage
COPY --from=builder /usr/src/server/target/debug/server .

# Expose the port the Actix server will listen on
EXPOSE 8080


# Command to run the Actix server
CMD ["./server"]
