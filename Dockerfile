# Use uma imagem base do Ubuntu
FROM ubuntu:20.04

# Instale dependências necessárias
RUN apt-get update && apt-get install -y \
  git \
  wget \
  curl \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  lib32stdc++6 \
  lib32z1

# Baixe e instale o Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /usr/local/flutter

# Adicione o Flutter ao PATH
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verifique a versão do Flutter e do Dart SDK
RUN flutter doctor -v

# Configure o diretório seguro do Git para o Flutter
RUN git config --global --add safe.directory /usr/local/flutter

# Aceite os termos de licença para Android SDK (necessário para algumas versões do Flutter)
RUN yes | flutter doctor --android-licenses || true

# Defina o diretório de trabalho para o projeto Flutter
WORKDIR /app

# Copie os arquivos do projeto Flutter para o contêiner
COPY . .

# Instale as dependências do Flutter e do Dart SDK
RUN flutter pub get

# Construa a aplicação Flutter para Web
RUN flutter build web

# Use o Nginx para servir a aplicação Flutter Web
FROM nginx:alpine

# Copiar a build do Flutter Web para o diretório padrão do Nginx
COPY --from=0 /app/build/web /usr/share/nginx/html

# Expor a porta 80 para acessar o servidor web
EXPOSE 80

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
