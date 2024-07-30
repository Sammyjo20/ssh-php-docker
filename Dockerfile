FROM alpine:latest

# Install Go, Git, Sudo & Bash

RUN apk update && apk add go git sudo bash

RUN export PATH=$PATH:/usr/local/bin/go

# Install PHP & Composer

RUN apk add \
    php php-cli php-common php-zip php-mbstring php-curl php-xml php-pear \
    php-bcmath php-tokenizer php-dom php-simplexml php-xmlwriter composer

# Create a separate user to run the SSH shell which is more secure

RUN adduser server --disabled-password

# Allow the user access to their home directory

RUN chown -R server:server /home/server

# Set the working directory to the home

WORKDIR /app/build

# Copy our very basic script

COPY ./src/main.go .

RUN go mod init sammyjo20/ssh-php

# Install Dependencies

RUN go get github.com/charmbracelet/log \
    github.com/charmbracelet/ssh \
    github.com/charmbracelet/wish \
    github.com/charmbracelet/wish/logging \
    github.com/creack/pty

# Build the image

RUN env go build main.go

# Copy the file to /home/server

RUN cp main /home/server/main

# Change work directory

WORKDIR /home/server

# Give the server user permission to run and use the server

RUN chown server:server main

# Expose Port 22

EXPOSE 22

# Switch to user

USER server

# Start the server

ENTRYPOINT ["./main"]
