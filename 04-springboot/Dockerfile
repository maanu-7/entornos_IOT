# ---------- Etapa 1: compilar con Maven y el JDK ----------
FROM maven:3.9-eclipse-temurin-21 AS construccion
WORKDIR /app

# Primero solo el pom: las dependencias se descargan una vez y quedan en caché
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Después el código, que es lo que cambia en cada compilación
COPY src ./src
RUN mvn -B -q package -DskipTests

# ---------- Etapa 2: la imagen final, solo con el JRE y el jar ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Usuario sin privilegios
RUN useradd --system --no-create-home spring
USER spring

COPY --from=construccion /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
