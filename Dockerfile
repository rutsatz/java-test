FROM eclipse-temurin:17.0.3_7-jdk-alpine as builder

WORKDIR /src
COPY . .

RUN ./gradlew clean build -x test

FROM eclipse-temurin:17.0.3_7-jre-alpine

COPY --from=builder src/build/libs/test*T.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
