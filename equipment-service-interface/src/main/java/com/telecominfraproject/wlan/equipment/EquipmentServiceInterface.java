package com.telecominfraproject.wlan.equipment;

import java.util.List;
import java.util.Set;

import com.telecominfraproject.wlan.core.model.pagination.ColumnAndSort;
import com.telecominfraproject.wlan.core.model.pagination.PaginationContext;
import com.telecominfraproject.wlan.core.model.pagination.PaginationResponse;

import com.telecominfraproject.wlan.equipment.models.Equipment;


/**
 * @author dtoptygin
 *
 */
public interface EquipmentServiceInterface {
    
    /**
     * Creates new Equipment
     *  
     * @param Equipment
     * @return stored Equipment object
     * @throws RuntimeException if Equipment record already exists
     */
    Equipment create(Equipment equipment );
    
    /**
     * Retrieves Equipment by id
     * @param equipmentId
     * @return Equipment for the supplied id
     * @throws RuntimeException if Equipment record does not exist
     */
    Equipment get(long equipmentId );

    /**
     * Retrieves Equipment by id
     * @param equipmentId
     * @return Equipment for the supplied id
     */
    Equipment getOrNull(long equipmentId );

    /**
     * Retrieves a list of Equipment records that which have their Id in the provided set.
     * 
     * @param equipmentIdSet
     * @return list of matching Equipment objects.
     */
    List<Equipment> get(Set<Long> equipmentIdSet);

    /**
     * Updates Equipment 
     * 
     * @param Equipment
     * @return updated Equipment object
     * @throws RuntimeException if Equipment record does not exist or if it was modified concurrently
     */
    Equipment update(Equipment equipment);
    
    /**
     * Deletes Equipment
     * 
     * @param equipmentId
     * @return deleted Equipment object
     */
    Equipment delete(long equipmentId );
    
    /**
     * <br>Retrieves all of the Equipment records that are mapped to the provided customerId.
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
	 *<li> "name"
     *<br> 
     * @param customerId
     * @return next page of matching Equipment objects.
     */
    PaginationResponse<Equipment> getForCustomer(int customerId, List<ColumnAndSort> sortBy, PaginationContext<Equipment> context);

}
