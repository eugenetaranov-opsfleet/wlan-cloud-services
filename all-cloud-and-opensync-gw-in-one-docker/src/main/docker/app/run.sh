#!/bin/bash

#no need for extra profiles here - defaults in application.properties are enough
#PROFILES=" -Dspring.profiles.include="

SSL_PROPS=" "
SSL_PROPS+=" -Dssl.props=file:/opt/tip-wlan/certs/ssl.properties"
SSL_PROPS+=" -Dtip.wlan.httpClientConfig=file:/opt/tip-wlan/certs/httpClientConfig.json"

CLIENT_MQTT_SSL_PROPS=" "
CLIENT_MQTT_SSL_PROPS+=" -Djavax.net.ssl.keyStore=/opt/tip-wlan/certs/client_keystore.jks"
CLIENT_MQTT_SSL_PROPS+=" -Djavax.net.ssl.keyStorePassword=mypassword"
CLIENT_MQTT_SSL_PROPS+=" -Djavax.net.ssl.trustStore=/opt/tip-wlan/certs/truststore.jks"
CLIENT_MQTT_SSL_PROPS+=" -Djavax.net.ssl.trustStorePassword=mypassword"
CLIENT_MQTT_SSL_PROPS+=" -Dconnectus.mqttBroker.password=admin"

OVSDB_PROPS=" "
OVSDB_PROPS+=" -Dconnectus.ovsdb.managerAddr=opensync-controller"
OVSDB_PROPS+=" -Dconnectus.ovsdb.listenPort=6640 "
OVSDB_PROPS+=" -Dconnectus.ovsdb.redirector.listenPort=6643"
OVSDB_PROPS+=" -Dconnectus.ovsdb.timeoutSec=30"
OVSDB_PROPS+=" -Dconnectus.ovsdb.trustStore=/opt/tip-wlan/certs/truststore.jks"
OVSDB_PROPS+=" -Dconnectus.ovsdb.keyStore=/opt/tip-wlan/certs/server.pkcs12"
OVSDB_PROPS+=" -Dconnectus.ovsdb.customerEquipmentFileName=$OVSDB_EQUIPMENT_CONFIG_FILE"
OVSDB_PROPS+=" -Dconnectus.ovsdb.apProfileFileName=$OVSDB_APPROFILE_CONFIG_FILE"
OVSDB_PROPS+=" -Dconnectus.ovsdb.ssidProfileFileName=$OVSDB_SSIDPROFILE_CONFIG_FILE"
OVSDB_PROPS+=" -Dconnectus.ovsdb.radiusProfileFileName=$OVSDB_RADIUSPROFILE_CONFIG_FILE"
OVSDB_PROPS+=" -Dconnectus.ovsdb.locationFileName=$OVSDB_LOCATION_CONFIG_FILE"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-iface.default_bridge=$OVSDB_IF_DEFAULT_BRIDGE"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-iface.default_radio0=$OVSDB_IF_DEFAULT_RADIO_0"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-iface.default_radio1=$OVSDB_IF_DEFAULT_RADIO_1"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-iface.default_radio2=$OVSDB_IF_DEFAULT_RADIO_2"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-device.radio0=$OVSDB_DEVICE_RADIO_0"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-device.radio1=$OVSDB_DEVICE_RADIO_1"
OVSDB_PROPS+=" -Dconnectus.ovsdb.wifi-device.radio2=$OVSDB_DEVICE_RADIO_2"

echo OVSDB_PROPS $OVSDB_PROPS

MQTT_PROPS=" "
MQTT_PROPS+=" -Dconnectus.mqttBroker.address=tip-wlan-opensync-mqtt-broker"
MQTT_PROPS+=" -Dconnectus.mqttBroker.listenPort=1883"

LOGGING_PROPS=" -Dlogging.config=file:/app/opensync/logback.xml"

RESTAPI_PROPS=" "
RESTAPI_PROPS+=" -Dserver.port=443  -Dtip.wlan.secondaryPort=444 "
RESTAPI_PROPS+=" -Dtip.wlan.introspectTokenApi.host=localhost:444 "

echo "REST APIs are available over port 443 with client certificate auth, and over port 444 with webtoken auth"
echo "Documentation for the supported REST APIs is at "
echo "https://github.com/Telecominfraproject/wlan-cloud-services/blob/master/portal-services/src/main/resources/portal-services-openapi.yaml "

SPRING_EXTRA_PROPS=" --add-opens java.base/java.lang=ALL-UNNAMED"

export ALL_PROPS="$PROFILES $SSL_PROPS $CLIENT_MQTT_SSL_PROPS $OVSDB_PROPS $MQTT_PROPS $LOGGING_PROPS $RESTAPI_PROPS $SPRING_EXTRA_PROPS"

java $ALL_PROPS -jar app.jar