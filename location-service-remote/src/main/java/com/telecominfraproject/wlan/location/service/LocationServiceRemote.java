package com.telecominfraproject.wlan.location.service;

import java.util.Collections;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import com.telecominfraproject.wlan.core.client.BaseRemoteClient;
import com.telecominfraproject.wlan.core.model.json.BaseJsonModel;
import com.telecominfraproject.wlan.core.model.pagination.ColumnAndSort;
import com.telecominfraproject.wlan.core.model.pagination.PaginationContext;
import com.telecominfraproject.wlan.core.model.pagination.PaginationResponse;
import com.telecominfraproject.wlan.datastore.exceptions.DsDataValidationException;
import com.telecominfraproject.wlan.location.models.Location;

@Component
public class LocationServiceRemote extends BaseRemoteClient implements LocationServiceInterface{

    private static final Logger LOG = LoggerFactory.getLogger(LocationServiceRemote.class);

    private static final ParameterizedTypeReference<List<Location>> Location_LIST_CLASS_TOKEN = new ParameterizedTypeReference<List<Location>>() {};

    private static final ParameterizedTypeReference<PaginationResponse<Location>> Location_PAGINATION_RESPONSE_CLASS_TOKEN = new ParameterizedTypeReference<PaginationResponse<Location>>() {};

    
    private String baseUrl;

    public String getBaseUrl() {
        if(baseUrl==null){
            baseUrl = environment.getProperty("tip.wlan.locationServiceBaseUrl").trim() + "/api/location";
        }
        return baseUrl;
    }
    
    @Override
    public Location create(Location location) {
        LOG.debug("create({})", location);
        if (BaseJsonModel.hasUnsupportedValue(location)) {
            LOG.error("Failed to create Location, unsupported value in configuration {}",
                    location);
            throw new DsDataValidationException("Location contains unsupported value");
        }
        
        HttpEntity<String> request = new HttpEntity<>(location.toString(), headers);
        ResponseEntity<Location> responseEntity = restTemplate.postForEntity(
                getBaseUrl(), request,
                Location.class);
        Location result = responseEntity.getBody();

        LOG.debug("create({}) returned {}", location, result);

        return result;
    }

    @Override
    public Location get(long locationId) {
        LOG.debug("get({})", locationId);

        ResponseEntity<Location> responseEntity = restTemplate.getForEntity(
                getBaseUrl() + "?locationId={locationId}",
                Location.class, locationId);

        Location result = responseEntity.getBody();

        LOG.debug("get({}) returned {}", locationId, result);
        return result;
    }
    
	@Override
	public List<Location> get(Set<Long> locationIdSet) {
		
        LOG.debug("get({})", locationIdSet);

        if (locationIdSet == null || locationIdSet.isEmpty()) {
            return Collections.emptyList();
        }

        String setString = locationIdSet.toString().substring(1, locationIdSet.toString().length() - 1);
        
        try {
            ResponseEntity<List<Location>> responseEntity = restTemplate.exchange(
                    getBaseUrl() + "/inSet?locationIdSet={locationIdSet}", HttpMethod.GET,
                    null, Location_LIST_CLASS_TOKEN, setString);

            List<Location> result = responseEntity.getBody();
            if (null == result) {
                result = Collections.emptyList();
            }
            LOG.debug("get({}) return {} entries", locationIdSet, result.size());
            return result;
        } catch (Exception exp) {
            LOG.error("getAllInSet({}) exception ", locationIdSet, exp);
            throw exp;
        }

	}

	@Override
	public PaginationResponse<Location> getForCustomer(int customerId, List<ColumnAndSort> sortBy,
			PaginationContext<Location> context) {
		
        LOG.debug("calling getForCustomer( {}, {}, {} )", customerId, sortBy, context);

        ResponseEntity<PaginationResponse<Location>> responseEntity = restTemplate.exchange(
                getBaseUrl()
                        + "/forCustomer?customerId={customerId}&sortBy={sortBy}&paginationContext={paginationContext}",
                HttpMethod.GET, null, Location_PAGINATION_RESPONSE_CLASS_TOKEN, customerId, sortBy, context);

        PaginationResponse<Location> ret = responseEntity.getBody();
        LOG.debug("completed getForCustomer {} ", ret.getItems().size());

        return ret;
	}

    @Override
    public Location update(Location location) {
    	
        if (BaseJsonModel.hasUnsupportedValue(location)) {
            LOG.error("Failed to update location, unsupported value in configuration {}", location);
            throw new DsDataValidationException("Location contains unsupported value");
        }

        LOG.debug("update({})", location);

        HttpEntity<String> request = new HttpEntity<>(location.toString(), headers);

        ResponseEntity<Location> responseEntity = restTemplate.exchange(getBaseUrl(), HttpMethod.PUT, request, Location.class);

        Location result = responseEntity.getBody();
        LOG.debug("update({}) returned {}", location, result);
        return result;

    }
    
    @Override
    public Location delete(long locationId) {
        LOG.debug("delete({})", locationId);

        ResponseEntity<Location> responseEntity = restTemplate.exchange(
                getBaseUrl() + "?locationId={locationId}", HttpMethod.DELETE,
                null, Location.class, locationId);

        Location result = responseEntity.getBody();
        LOG.debug("delete({}) returned {}", locationId, result);
        return result;

    }
    
    @Override
    public Location getTopLevelLocation(long locationId) {
        LOG.debug("getTopLevelLocation({})", locationId);

        ResponseEntity<Location> responseEntity = restTemplate.exchange(
                getBaseUrl() + "/top?locationId={locationId}", HttpMethod.GET,
                null, Location.class, locationId);

        Location result = responseEntity.getBody();
        LOG.debug("getTopLevelLocation({}) returned {}", locationId, responseEntity);
        return result;
    }
    
    @Override
    public List<Location> getAllForCustomer(int customerId) {
        LOG.debug("getAllForCustomer({})", customerId);

        ResponseEntity<List<Location>> responseEntity = restTemplate.exchange(
                getBaseUrl() + "/allForCustomer?customerId={customerId}", HttpMethod.GET,
                null, Location_LIST_CLASS_TOKEN, customerId);

        List<Location> result = responseEntity.getBody();

        LOG.debug("getAllForCustomer({}) returned {} entries", customerId,
                (null == result) ? 0 : result.size());
        return result;
    }
    
    @Override
    public List<Location> getAllDescendants(long locationId) {
        LOG.debug("getAllDescendants({})", locationId);

        ResponseEntity<List<Location>> responseEntity = restTemplate.exchange(
                getBaseUrl() + "/allDescendants?locationId={locationId}", HttpMethod.GET,
                null, Location_LIST_CLASS_TOKEN, locationId);

        List<Location> result = responseEntity.getBody();

        LOG.debug("getAllDescendants({}) returned {} entries", locationId,
                (null == result) ? 0 : result.size());
        return result;
    }
}
