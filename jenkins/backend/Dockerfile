# Backend Dockerfile with multi-stage build

# Build stage
FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run stage
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/backend-app.jar app.jar
EXPOSE 5000
ENTRYPOINT ["java", "-jar", "app.jar"]
