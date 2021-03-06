package com.telecominfraproject.wlan.client.models.events;

import com.telecominfraproject.wlan.client.models.Client;
import com.telecominfraproject.wlan.systemevent.models.CustomerEvent;

/**
 * @author dtoptygin
 *
 */
public class ClientAddedEvent extends CustomerEvent<Client> {
    private static final long serialVersionUID = 7142208487917559985L;

    public ClientAddedEvent(Client client){
        super(client.getCustomerId(), client.getLastModifiedTimestamp(), client);
    }
    
    /**
     * Constructor used by JSON
     */
    public ClientAddedEvent() {
        super(0, 0, null);
    }
    
}
