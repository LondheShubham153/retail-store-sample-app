# Build Stage
FROM eclipse-temurin:21-jdk AS build-env

RUN apt-get update && apt-get install -y \
    maven \
    && rm -rf /var/lib/apt/lists/*

VOLUME /tmp
WORKDIR /

COPY .mvn .mvn
COPY mvnw .

RUN chmod +x mvnw && sed -i 's/\r//' mvnw
COPY pom.xml .

RUN ./mvnw dependency:go-offline -B

COPY ./src ./src

RUN ./mvnw -DskipTests package && \
    mv /target/ui-0.0.1-SNAPSHOT.jar /app.jar

# Package Stage
FROM eclipse-temurin:21-jre

ENV APPUSER=appuser
ENV APPUID=1000
ENV APPGID=1000

RUN useradd \
    --home-dir "/app" \
    --create-home \
    --user-group \
    --uid "$APPUID" \
    --non-unique \
    "$APPUSER"

ENV JAVA_TOOL_OPTIONS=
ENV SPRING_PROFILES_ACTIVE=prod

WORKDIR /app
USER appuser

COPY ./ATTRIBUTION.md ./LICENSES.md
COPY --chown=appuser:appuser --from=build-env /app.jar .

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
