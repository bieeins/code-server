FROM alpine:3.20

# Install dependency
RUN apk add --no-cache \
    ca-certificates \
    curl \
    bash \
    sudo \
    git \
    nano \
    vim \
    openssh-client \
    nodejs \
    npm

# Install VS Code CLI
RUN curl -fL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" \
      -o /tmp/vscode_cli_alpine_x64_cli.tar.gz \
    && tar -xzf /tmp/vscode_cli_alpine_x64_cli.tar.gz -C /usr/local/bin \
    && rm /tmp/vscode_cli_alpine_x64_cli.tar.gz

# Install PHP 8.2 extension
RUN apk update && apk add --no-cache \
    php82 php82-cli php82-common php82-phar \
    php82-mbstring php82-xml php82-xmlwriter php82-dom \
    php82-ctype php82-json php82-tokenizer php82-fileinfo \
    php82-openssl php82-curl php82-intl \
    php82-pdo php82-pdo_mysql php82-mysqli \
    php82-zip php82-simplexml php82-gd \
    php82-session php82-iconv php82-posix \
    php82-pcntl php82-opcache \
    && ln -sf /usr/bin/php82 /usr/local/bin/php \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"


# Tambah user non-root dengan UID ( tergantung uuid dari host )
RUN addgroup -g 1001 vscode \
    && adduser -D -u 1001 -G vscode vscodeuser \
    && echo "vscodeuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/vscodeuser/.vscode-server \
    && chown -R vscodeuser:vscode /home/vscodeuser

# Copy start.sh
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh \
    && chown vscodeuser:vscode /usr/local/bin/start.sh

USER vscodeuser
WORKDIR /workspaces

ENV PORT=8585
ENV HOST=0.0.0.0
ENV SERVER_DATA_DIR=/home/vscodeuser/.vscode-server

EXPOSE 8585

ENTRYPOINT ["/usr/local/bin/start.sh"]
