# Step 1: 애플리케이션 빌드
FROM gradle:jdk17 AS builder
WORKDIR /app

# 필요한 파일들을 복사합니다.
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src

# gradlew 스크립트에 실행 권한을 부여합니다.
RUN chmod +x gradlew

# Gradle 빌드를 실행합니다.
RUN ./gradlew build --no-daemon --stacktrace --info

# Step 2: 최종 이미지 생성 및 실행
FROM openjdk:17-jdk-slim
WORKDIR /app

# 빌드된 JAR 파일을 복사합니다.
COPY --from=builder /app/build/libs/*.jar ./app.jar

ENV PORT=8080
EXPOSE ${PORT}
CMD ["java", "-jar", "app.jar"]
