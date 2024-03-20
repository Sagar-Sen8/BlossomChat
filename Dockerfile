# Use a base image with Java and Maven pre-installed
FROM maven:3.8.4-openjdk-17-slim AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project file and download dependencies
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copy the project source code
COPY src ./src

# Build the application
RUN mvn -B clean package -DskipTests

# Use a lightweight base image with Java only
FROM openjdk:17-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/bolossom-chat-0.0.1-SNAPSHOT.jar .

# Expose the port on which the Spring Boot application will run
EXPOSE 8091

# Specify the command to run the Spring Boot application
CMD ["java", "-jar", "bolossom-chat-0.0.1-SNAPSHOT.jar"]
