package com.telecominfraproject.wlan.client.datastore.rdbms;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import com.telecominfraproject.wlan.core.server.jdbc.BaseDataSourceConfig;

/**
 * @author dtoptygin
 *
 */
@Component
@Profile("!use_single_ds")
@PropertySource({ "${client-ds.props:classpath:client-ds.properties}" })
public class ClientDataSourceConfig extends BaseDataSourceConfig {

    
    @Bean
    public ClientDataSourceInterface clientDataSourceInterface(){
        
        ClientDataSourceInterface ret = new ClientDataSourceImpl(getDataSource(), getKeyColumnConverter());
        return ret;
    }
    
    @Override
    public String getDataSourceName() {
        return "client-ds";
    }
}
