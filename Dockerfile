FROM adoptopenjdk/openjdk8:alpine as common
LABEL maintainer="udger.com" description="Udger local parser"
ENV MEECROWAVE_ARCHIVE meecrowave-core-1.2.15-runner
ENV INSTALL_DIR /opt
RUN apk -U upgrade \
    && apk add curl \
    && curl -o ${INSTALL_DIR}/${MEECROWAVE_ARCHIVE}.jar -L https://repo1.maven.org/maven2/org/apache/meecrowave/meecrowave-core/1.2.15/meecrowave-core-1.2.15-runner.jar
ENV MEECROWAVE_HOME ${INSTALL_DIR}
ENV DEPLOYMENT_DIR ${MEECROWAVE_HOME}
WORKDIR ${INSTALL_DIR}
COPY ./target/udger-local-api-v4.war ${DEPLOYMENT_DIR}
RUN mkdir -p /udgerdb

FROM common as dev

COPY ./udgerdb_test_v4.dat /udgerdb/udger_test_v4.dat
ENV JAVA_OPTS="-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -Dudger.db=/udgerdb/udger_test_v4.dat"
ENTRYPOINT java ${JAVA_OPTS} -jar ${MEECROWAVE_ARCHIVE}.jar --webapp udger-local-api-v4.war --context udger-local-api-v4
EXPOSE 8080

FROM common as prod

COPY ./udgerdb_v4.dat /udgerdb/udgerdb_v4.dat
ENV JAVA_OPTS="-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true"
ENTRYPOINT java ${JAVA_OPTS} -jar ${MEECROWAVE_ARCHIVE}.jar --webapp udger-local-api-v4.war --context udger-local-api-v4
EXPOSE 8080
