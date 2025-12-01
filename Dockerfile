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

# Install PHP 8.3 extension
RUN apk update && apk add --no-cache \
    php83 php83-cli php83-common php83-phar \
    php83-mbstring php83-xml php83-xmlwriter php83-dom \
    php83-ctype php83-json php83-tokenizer php83-fileinfo \
    php83-openssl php83-curl php83-intl \
    php83-pdo php83-pdo_mysql php83-mysqli \
    php83-zip php83-simplexml php83-gd \
    php83-session php83-iconv php83-posix \
    php83-pcntl php83-opcache \
    && ln -sf /usr/bin/php83 /usr/local/bin/php \
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
