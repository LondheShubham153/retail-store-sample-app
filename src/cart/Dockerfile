# # Stage 1: Build
# FROM maven:3.9.6-eclipse-temurin-17 AS builder

# WORKDIR /app
# COPY pom.xml .
# RUN mvn dependency:go-offline

# COPY src ./src
# RUN mvn clean package -DskipTests

# # Stage 2: Run
# FROM eclipse-temurin:17-jdk-alpine

# WORKDIR /app
# COPY --from=builder /app/target/*.jar app.jar

# EXPOSE 8080
# ENTRYPOINT ["java","-jar","app.jar"]

# updated to use Java 21 for better performance and security, and to align with the latest LTS version of Java
# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]