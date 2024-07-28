FROM alpine:latest

# Install Go and Sudo

RUN apk update && apk add go git sudo bash

# Install PHP

RUN apk add php php-cli php-common php-zip php-mbstring php-curl php-xml php-pear php-bcmath composer

RUN export PATH=$PATH:/usr/local/bin/go

# Create a separate user to run the SSH shell which is more secure

RUN adduser server --disabled-password

# Allow the user access to their home directory

RUN chown -R server:server /home/server

# Set the working directory to the home

WORKDIR /app/build

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

ENTRYPOINT ["./main"]
