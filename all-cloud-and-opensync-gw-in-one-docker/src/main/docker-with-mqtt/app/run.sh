#!/bin/sh

# Prepare the hosts file - do it only if does not have required entries
n1=`grep opensync-mqtt-broker /etc/hosts | wc -l`

if [[ $n1 -eq 0  ]]
then
  echo Adding opensync-mqtt-broker to /etc/hosts
  echo "127.0.0.1 opensync-mqtt-broker" >> /etc/hosts
fi

n2=`grep opensync-wifi-controller /etc/hosts | wc -l`

if [[ $n2 -eq 0  ]]
then
  echo Adding opensync-wifi-controller to /etc/hosts
  echo "127.0.0.1 opensync-wifi-controller" >> /etc/hosts
fi


echo Starting mosquitto MQTT broker
/usr/sbin/mosquitto -d -c /etc/mosquitto/mosquitto.conf

# Provide default values for the environment variables
MQTT_CLIENT_KEYSTORE_PASSWORD="${MQTT_CLIENT_KEYSTORE_PASSWORD:=mypassword}"
MQTT_CLIENT_KEYSTORE_FILE="${MQTT_CLIENT_KEYSTORE_FILE:=/opt/tip-wlan/certs/client_keystore.jks}"
MQTT_TRUSTSTORE_FILE="${MQTT_TRUSTSTORE_FILE:=/opt/tip-wlan/certs/truststore.jks}"
MQTT_TRUSTSTORE_PASSWORD="${MQTT_TRUSTSTORE_PASSWORD:=mypassword}"

OVSDB_SERVER_KEYSTORE_FILE="${OVSDB_SERVER_KEYSTORE_FILE:=/opt/tip-wlan/certs/server.pkcs12}"
OVSDB_SERVER_KEYSTORE_PASSWORD="${OVSDB_SERVER_KEYSTORE_PASSWORD:=mypassword}"
OVSDB_SERVER_TRUSTSTORE_FILE="${OVSDB_SERVER_TRUSTSTORE_FILE:=/opt/tip-wlan/certs/truststore.jks}"
OVSDB_SERVER_TRUSTSTORE_PASSWORD="${OVSDB_SERVER_TRUSTSTORE_PASSWORD:=mypassword}"
OVSDB_EQUIPMENT_CONFIG_FILE="${OVSDB_EQUIPMENT_CONFIG_FILE:=/app/opensync/EquipmentExample.json}"
OVSDB_APPROFILE_CONFIG_FILE="${OVSDB_AP_PROFILE_CONFIG_FILE:=/app/opensync/ProfileAPExample.json}"
OVSDB_SSIDPROFILE_CONFIG_FILE="${OVSDB_SSIDPROFILE_CONFIG_FILE:=/app/opensync/ProfileSsid.json}"
OVSDB_LOCATION_CONFIG_FILE="${OVSDB_LOCATION_CONFIG_FILE:=/app/opensync/LocationBuildingExample.json}"
OVSDB_RADIUSPROFILE_CONFIG_FILE="${OVSDB_RADIUSPROFILE_CONFIG_FILE:=/app/opensync/ProfileRadius.json}"

OVSDB_IF_DEFAULT_BRIDGE="${OVSDB_IF_DEFAULT_BRIDGE:=br-home}"
echo $OVSDB_IF_DEFAULT_BRIDGE
OVSDB_IF_DEFAULT_RADIO_0="${OVSDB_IF_DEFAULT_RADIO_0:=home-ap-u50}"
echo $OVSDB_IF_DEFAULT_RADIO_0
OVSDB_IF_DEFAULT_RADIO_1="${OVSDB_IF_DEFAULT_RADIO_1:=home-ap-24}"
echo $OVSDB_IF_DEFAULT_RADIO_1
OVSDB_IF_DEFAULT_RADIO_2="${OVSDB_IF_DEFAULT_RADIO_2:=home-ap-l50}"
echo $OVSDB_IF_DEFAULT_RADIO_2
OVSDB_DEVICE_RADIO_0="${OVSDB_DEVICE_RADIO_0:=wifi2}"
echo $OVSDB_DEVICE_RADIO_0
OVSDB_DEVICE_RADIO_1="${OVSDB_DEVICE_RADIO_1:=wifi0}"
echo $OVSDB_DEVICE_RADIO_1
OVSDB_DEVICE_RADIO_2="${OVSDB_DEVICE_RADIO_2:=wifi1}"
echo $OVSDB_DEVICE_RADIO_2

echo Reading AP configuration from $OVSDB_CONFIG_FILE

EXT_CLIENT_KEYSTORE_PASSWORD="${EXT_CLIENT_KEYSTORE_PASSWORD:=mypassword}"
EXT_CLIENT_KEYSTORE_FILE="${EXT_CLIENT_KEYSTORE_FILE:=/opt/tip-wlan/certs/client_keystore.jks}"
EXT_TRUSTSTORE_FILE="${EXT_TRUSTSTORE_FILE:=/opt/tip-wlan/certs/truststore.jks}"
EXT_TRUSTSTORE_PASSWORD="${EXT_TRUSTSTORE_PASSWORD:=mypassword}"

MQTT_BROKER_HOST="${MQTT_BROKER_HOST:=opensync-mqtt-broker}"
OVSDB_MANAGER_HOST="${OVSDB_MANAGER_HOST:=opensync-wifi-controller}"

LOGBACK_CONFIG_FILE="${LOGBACK_CONFIG_FILE:=/app/opensync/logback.xml}"

# Create ssl.properties file
cat > /app/ssl.properties <<END_OF_FILE
truststorePass=$OVSDB_SERVER_TRUSTSTORE_PASSWORD
truststoreFile=file:$OVSDB_SERVER_TRUSTSTORE_FILE
truststoreType=JKS
truststoreProvider=SUN

keyAlias=1
keystorePass=$OVSDB_SERVER_KEYSTORE_PASSWORD
keystoreFile=file:$OVSDB_SERVER_KEYSTORE_FILE
keystoreType=pkcs12
keystoreProvider=SunJSSE

sslProtocol=TLS
END_OF_FILE

# Create httpClientConfig.json file
cat > /app/httpClientConfig.json <<END_OF_FILE
{
"maxConnectionsTotal":100,
"maxConnectionsPerRoute":10,
"truststoreType":"JKS",
"truststoreProvider":"SUN",
"truststoreFile":"file:$EXT_TRUSTSTORE_FILE",
"truststorePass":"$EXT_TRUSTSTORE_PASSWORD",
"keystoreType":"JKS",
"keystoreProvider":"SUN",
"keystoreFile":"file:$EXT_CLIENT_KEYSTORE_FILE",
"keystorePass":"$EXT_CLIENT_KEYSTORE_PASSWORD",
"keyAlias":"clientkeyalias",
"credentialsList":[
    {"host":"localhost","port":-1,"user":"user","password":"password"}
    ]

}
END_OF_FILE

# Set environment for the cloud and opensync gateway process

#no need for extra profiles here - defaults in application.properties are enough
#PROFILES=" -Dspring.profiles.include="

SSL_PROPS=" "
SSL_PROPS="$SSL_PROPS -Dssl.props=file:/app/ssl.properties"
SSL_PROPS="$SSL_PROPS -Dtip.wlan.httpClientConfig=file:/app/httpClientConfig.json"

CLIENT_MQTT_SSL_PROPS=" "
CLIENT_MQTT_SSL_PROPS="$CLIENT_MQTT_SSL_PROPS -Djavax.net.ssl.keyStore=$MQTT_CLIENT_KEYSTORE_FILE"
CLIENT_MQTT_SSL_PROPS="$CLIENT_MQTT_SSL_PROPS -Djavax.net.ssl.keyStorePassword=$MQTT_CLIENT_KEYSTORE_PASSWORD"
CLIENT_MQTT_SSL_PROPS="$CLIENT_MQTT_SSL_PROPS -Djavax.net.ssl.trustStore=$MQTT_TRUSTSTORE_FILE"
CLIENT_MQTT_SSL_PROPS="$CLIENT_MQTT_SSL_PROPS -Djavax.net.ssl.trustStorePassword=$MQTT_TRUSTSTORE_PASSWORD"

OVSDB_PROPS=" "
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.managerAddr=$OVSDB_MANAGER_HOST"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.listenPort=6640 "
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.redirector.listenPort=6643"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.timeoutSec=30"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.trustStore=$OVSDB_SERVER_TRUSTSTORE_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.trustStorePassword=$OVSDB_SERVER_TRUSTSTORE_PASSWORD"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.keyStore=$OVSDB_SERVER_KEYSTORE_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.keyStorePassword=$OVSDB_SERVER_KEYSTORE_PASSWORD"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.customerEquipmentFileName=$OVSDB_EQUIPMENT_CONFIG_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.apProfileFileName=$OVSDB_APPROFILE_CONFIG_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.ssidProfileFileName=$OVSDB_SSIDPROFILE_CONFIG_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.radiusProfileFileName=$OVSDB_RADIUSPROFILE_CONFIG_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.locationFileName=$OVSDB_LOCATION_CONFIG_FILE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-iface.default_bridge=$OVSDB_IF_DEFAULT_BRIDGE"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-iface.default_radio0=$OVSDB_IF_DEFAULT_RADIO_0"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-iface.default_radio1=$OVSDB_IF_DEFAULT_RADIO_1"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-iface.default_radio2=$OVSDB_IF_DEFAULT_RADIO_2"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-device.radio0=$OVSDB_DEVICE_RADIO_0"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-device.radio1=$OVSDB_DEVICE_RADIO_1"
OVSDB_PROPS="$OVSDB_PROPS -Dconnectus.ovsdb.wifi-device.radio2=$OVSDB_DEVICE_RADIO_2"

echo OVSDB_PROPS $OVSDB_PROPS


MQTT_PROPS=" "
MQTT_PROPS="$MQTT_PROPS -Dconnectus.mqttBroker.address=$MQTT_BROKER_HOST"
MQTT_PROPS="$MQTT_PROPS -Dconnectus.mqttBroker.listenPort=1883"

LOGGING_PROPS=" -Dlogging.config=file:$LOGBACK_CONFIG_FILE"

RESTAPI_PROPS=" "
RESTAPI_PROPS="$RESTAPI_PROPS -Dserver.port=4043 -Dtip.wlan.secondaryPort=4044 "
RESTAPI_PROPS="$RESTAPI_PROPS -Dtip.wlan.introspectTokenApi.host=localhost:4044 "

echo "REST APIs are available over port 4043 with client certificate auth, and over port 4044 with webtoken auth"
echo "Documentation for the supported REST APIs is at "
echo "https://github.com/Telecominfraproject/wlan-cloud-services/blob/master/portal-services/src/main/resources/portal-services-openapi.yaml "

SPRING_EXTRA_PROPS=" --add-opens java.base/java.lang=ALL-UNNAMED"

export ALL_PROPS="$PROFILES $SSL_PROPS $CLIENT_MQTT_SSL_PROPS $OVSDB_PROPS $MQTT_PROPS $LOGGING_PROPS $RESTAPI_PROPS $SPRING_EXTRA_PROPS "

echo Starting dynamic opensync wifi controller

#echo Result: $ALL_PROPS
java $ALL_PROPS -jar app.jar > /app/opensync-wifi-controller-stdout.out 2>&1

