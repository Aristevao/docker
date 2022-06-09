FROM maven:4.0.0-jdk-11 as build
WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:8
WORKDIR /app
COPY -- from=build ./build/target/*.jar ./application.jar
EXPOSE 8080

ENTRYPOINT java -jar