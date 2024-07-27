FROM ubuntu:24.04

# Create a separate user to run the SSH shell which is more secure

RUN useradd -ms /bin/bash -d /home/server server
RUN chown -R server:server /home/server

# Set the working directory to the home

WORKDIR /home/server

# Install Go

RUN apt update && apt install golang git php php-cli sudo -y

RUN export PATH=$PATH:/usr/local/bin/go

# Copy our very basic script

COPY ./src/main.go .

RUN go mod init sammyjo20/jourminal

# Install Dependencies

RUN go get github.com/charmbracelet/log \
    github.com/charmbracelet/ssh \
    github.com/charmbracelet/wish \
    github.com/charmbracelet/wish/logging \
    github.com/creack/pty

# Build the image

RUN env go build main.go

# Expose Port 22

EXPOSE 22

# Switch to user

USER server

ENTRYPOINT ["./main"]
