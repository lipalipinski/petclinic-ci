FROM sapmachine:17.0.6
WORKDIR /opt/app
ARG jarfile=*.jar
COPY $jarfile app.jar
EXPOSE 8080
CMD [ "java", "-jar", "app.jar" ]