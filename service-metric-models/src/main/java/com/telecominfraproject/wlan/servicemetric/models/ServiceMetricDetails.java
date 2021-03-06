package com.telecominfraproject.wlan.servicemetric.models;

import java.util.Objects;

import com.telecominfraproject.wlan.core.model.json.BaseJsonModel;

/**
 * @author dtoptygin
 *
 */
public abstract class ServiceMetricDetails extends BaseJsonModel {
    
	private static final long serialVersionUID = 5570757656953699233L;
	
    public abstract ServiceMetricDataType getDataType();

	@Override
	public boolean hasUnsupportedValue() {
		if (super.hasUnsupportedValue()) {
			return true;
		}

		return false;
	}
	
    @Override
    public ServiceMetricDetails clone() {
        return (ServiceMetricDetails) super.clone();
    }

	@Override
	public int hashCode() {
		return Objects.hash(getDataType());
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (!(obj instanceof ServiceMetricDetails)) {
			return false;
		}
		ServiceMetricDetails other = (ServiceMetricDetails) obj;
		return Objects.equals(getDataType(), other.getDataType());
	}
    
}
