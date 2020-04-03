package com.telecominfraproject.wlan.location.datastore.rdbms;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.Transactional;

import com.telecominfraproject.wlan.location.datastore.LocationDatastore;
import com.telecominfraproject.wlan.location.models.Location;

/**
 * @author dtoptygin
 *
 */
@Transactional
@Configuration
public class LocationDatastoreRdbms implements LocationDatastore {
    
    @Autowired LocationDAO locationDAO;

	@Override
	public List<Location> getAllForCustomer(int customerId) {
		return locationDAO.getAllLocationsForCustomer(customerId);
	}

	@Override
	public Location get(long locationId) {
		return locationDAO.get(locationId);
	}

	@Override
	public Location create(Location location) {
		return locationDAO.create(location);
	}

	@Override
	public Location update(Location location) {
		return locationDAO.update(location);
	}

	@Override
	public Location delete(long locationId) {
		return locationDAO.delete(locationId);
	}

	@Override
	public List<Location> getAllDescendants(long locationParentId) {
		return locationDAO.getAllDescendants(locationParentId);
	}

	@Override
	public Location getTopLevelLocation(long locationId) {
		return locationDAO.getTopLevelLocation(locationId);
	}

}
