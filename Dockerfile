# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create a minimal image to run the app
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose your desired port (we'll use 8081 as before)
EXPOSE 8081

# Set default command
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8085", "--server.address=0.0.0.0"]
