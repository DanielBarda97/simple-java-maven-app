FROM maven:3.8.6-openjdk-11-slim AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests


FROM maven:3.8.6-openjdk-11-slim AS tests
WORKDIR /app
COPY --from=builder /app .
RUN mvn clean test


FROM maven:3.8.6-openjdk-11-slim as production
COPY --from=builder /app/target/*.jar /app/
CMD bash -c "java -jar /app/*.jar"