package com.telecominfraproject.wlan.portaluser.datastore;

import java.util.List;
import java.util.Set;

import com.telecominfraproject.wlan.core.model.pagination.ColumnAndSort;
import com.telecominfraproject.wlan.core.model.pagination.PaginationContext;
import com.telecominfraproject.wlan.core.model.pagination.PaginationResponse;

import com.telecominfraproject.wlan.portaluser.models.PortalUser;

/**
 * @author dtoptygin
 *
 */
public interface PortalUserDatastore {

    PortalUser create(PortalUser portalUser);
    PortalUser get(long portalUserId);
    PortalUser getOrNull(long portalUserId);
    PortalUser update(PortalUser portalUser);
    PortalUser delete(long portalUserId);
    
    /**
     * Retrieves a list of PortalUser records that which have their Id in the provided set.
     * 
     * @param portalUserIdSet
     * @return list of matching PortalUser objects.
     */
    List<PortalUser> get(Set<Long> portalUserIdSet);

    /**
     * <br>Retrieves all of the PortalUser records that are mapped to the provided customerId.
     * Results are returned in pages.
     * 
     * <br>When changing sort order or filters, pagination should be restarted again from the first page. 
     * Old pagination contexts would be invalid and should not be used in that case. 
     * <br>The only time when a caller should be interacting with the properties of the paginationContext is during the 
     * call to the first page by setting property maxItemsPerPage. 
     * <br>If initial context is not provided, then the maxItemsPerPage will be set to 20.
     * <br>If sortBy is not provided, then the data will be ordered by id.
     * <ul>Allowed columns for sorting are: 
	 *<li>  "id"
	 *<li> "sampleStr"
     *<br> 
     * @param customerId
     * @return next page of matching PortalUser objects.
     */
    PaginationResponse<PortalUser> getForCustomer(int customerId, List<ColumnAndSort> sortBy, PaginationContext<PortalUser> context);

    /**
     * @param customerId
     * @param username
     * @return PortalUser for the supplied username or null if it cannot be found
     */
    PortalUser getByUsernameOrNull(int customerId, String username);

}
