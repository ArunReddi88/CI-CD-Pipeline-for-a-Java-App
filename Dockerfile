# Stage 1: Build the app using Maven
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create lightweight image for runtime
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy the built JAR from stage 1
COPY --from=builder /app/target/*.jar app.jar

# Expose internal port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8080", "--server.address=0.0.0.0"]
