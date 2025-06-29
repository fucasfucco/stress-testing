FROM alpine/jmeter:5.6.3

ARG IMAGE_TIMEZONE="GMT"
ARG JVM_ARGS="-Xms4g -Xmx8g -XX:+UseG1GC -XX:MaxMetaspaceSize=1g"

ENV JVM_ARGS=$JVM_ARGS

COPY ./plugins/jmeter.backendlistener.elasticsearch-2.7.1.jar \
     ./plugins/jmeter-plugins-redis-0.7.jar \
     ./plugins/jedis-5.1.2.jar \
     ./plugins/jmeter-plugins-casutg-3.1.1.jar \
     ./plugins/jmeter-plugins-cmn-jmeter-0.7.jar \
     $JMETER_HOME/lib/ext/

COPY jmeter-client.entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh    

WORKDIR $JMETER_HOME/bin

EXPOSE 60000

ENTRYPOINT ["/entrypoint.sh"]
