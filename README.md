## Official Dockerfile for sammyjo20/ssh-php

[https://github.com/sammyjo20/ssh-php](https://github.com/sammyjo20/ssh-php)

## Testing

```
docker build . -t ssh-php && docker run -p 22:22 -v ./tests/Fixtures/index.php:/home/server/index.php ssh-php
```
