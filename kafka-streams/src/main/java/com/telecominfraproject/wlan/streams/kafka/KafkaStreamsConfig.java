package com.telecominfraproject.wlan.streams.kafka;

import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.telecominfraproject.wlan.servicemetric.models.ServiceMetric;
import com.telecominfraproject.wlan.stream.StreamInterface;
import com.telecominfraproject.wlan.systemevent.models.SystemEventRecord;

/**
 * @author dtop
 * This class configures producers of the messages to be pushed into Kafka - System Events and Service Metrics
 */
@Configuration
public class KafkaStreamsConfig {

    	private static final Logger LOG = LoggerFactory.getLogger(KafkaStreamsConfig.class);
	
        @Value("${tip.wlan.wlanServiceMetricsTopic:wlan_service_metrics}")
    	private String wlanServiceMetricsTopic;
        
        @Value("${tip.wlan.systemEventsTopic:system_events}")
    	private String systemEventsTopic;

        @Value("${tip.wlan.customerEventsTopic:customer_events}")
    	private String customerEventsTopic;

        /**
         * @param producer
         * @return interface for publishing wlan service metrics into a topic that is partitioned by customerId, equipmentId, clientMac and dataType.
         */
        @Bean
        public StreamInterface<ServiceMetric> metricStreamInterface(@Autowired Producer<String,  byte[]> producer) {
        	StreamInterface<ServiceMetric> si = new StreamInterface<ServiceMetric>() {

                {
                    LOG.info("*** Using kafka stream for the metrics");
                }
                
                @Override
                public void publish(ServiceMetric record) {
                	LOG.trace("publishing metric {}", record);
                	String recordKey = record.getCustomerId() + "_" + record.getEquipmentId() + "_" + record.getClientMac() + "_" + record.getDataType(); 
                	producer.send(new ProducerRecord<String, byte[]>(wlanServiceMetricsTopic, recordKey, record.toZippedBytes()));
                }
                
              };
              
              return si;
        }
        
        /**
         * @param producer
         * @return interface for publishing system events into a topic that is partitioned by customerId, equipmentId and dataType.
         */
        @Bean
        public StreamInterface<SystemEventRecord> eventStreamInterface(@Autowired Producer<String,  byte[]> producer) {
        	StreamInterface<SystemEventRecord> si = new StreamInterface<SystemEventRecord>() {

                {
                    LOG.info("*** Using kafka stream for the system events");
                }
                
                @Override
                public void publish(SystemEventRecord record) {
                	LOG.trace("publishing system event {}", record);
                	String recordKey = record.getCustomerId() + "_" + record.getEquipmentId() + "_" + record.getDataType(); 
                	producer.send(new ProducerRecord<String, byte[]>(systemEventsTopic, recordKey, record.toZippedBytes()));                	
                }
                
              };
              
              return si;
        }

        /**
		 * @param producer
		 * @return interface for publishing system invents into a topic that is
		 *         partitioned only by customerId - used to combine results of partial
		 *         aggregations into customer-centric view
		 */
        @Bean
        public StreamInterface<SystemEventRecord> customerEventStreamInterface(@Autowired Producer<String,  byte[]> producer) {
        	StreamInterface<SystemEventRecord> si = new StreamInterface<SystemEventRecord>() {

                {
                    LOG.info("*** Using kafka stream for the customer events");
                }
                
                @Override
                public void publish(SystemEventRecord record) {
                	LOG.trace("publishing customer event {}", record);
                	String recordKey = record.getCustomerId() + "_" + record.getDataType(); 
                	producer.send(new ProducerRecord<String, byte[]>(customerEventsTopic, recordKey, record.toZippedBytes()));                	
                }
                
              };
              
              return si;
        }


}
