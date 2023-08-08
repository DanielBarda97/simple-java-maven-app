FROM maven:3.8.6-openjdk-11-slim AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests


FROM maven:3.8.6-openjdk-11-slim AS tests
WORKDIR /app
COPY --from=builder /app .
RUN mvn clean test
