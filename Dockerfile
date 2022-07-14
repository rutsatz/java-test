FROM eclipse-temurin:17.0.3_7-jdk-alpine as builder

WORKDIR /src
COPY . .

RUN ./gradlew clean build -x test

FROM eclipse-temurin:17.0.3_7-jre-alpine

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY docker-compose.yml /docker-compose.yml

COPY --from=builder src/build/libs/test*T.jar app.jar

RUN apk add --no-cache openssl

# Usa o dockerize em dev para poder subir o banco e testar localmente
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

EXPOSE 8080

RUN chmod +x /docker-entrypoint.sh
# CMD ["java", "-jar", "app.jar"]
CMD ["docker-entrypoint.sh"]
