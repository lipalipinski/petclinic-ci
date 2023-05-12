# requires path to jar provided with arg $jarfile
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /opt/app
ARG jarfile
COPY $jarfile app.jar
EXPOSE 8080
CMD [ "java", "-jar", "app.jar" ]