FROM maven:3.8.4-jdk-11

COPY settings.xml /root/.m2/settings.xml

COPY target/simple-web-app.jar /app/simple-web-app.jar

CMD ["java", "-jar", "/app/simple-web-app.jar"]
