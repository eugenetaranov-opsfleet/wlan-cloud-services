package com.telecominfraproject.wlan.servicemetric.apnode.models;

import java.io.Serializable;
import java.util.List;

import org.springframework.util.CollectionUtils;

public class RadiusMetricsUtil implements Serializable {

    private static final long serialVersionUID = -7251281414326110503L;

    public static boolean isRadiusReachable(List<RadiusMetrics> radiusMetrics) {
        if(radiusMetrics==null){
            return true;
        } 
        
        boolean reachable = true;
        
        for(RadiusMetrics metrics : radiusMetrics)
        {
           if(metrics.getNumberOfNoAnswer()>0)
           {
              reachable = false;
              break;
           }
        }
        
        return reachable;
    }

    public static long getAvgRadiusLatency(List<RadiusMetrics> radiusMetrics) {
        if (CollectionUtils.isEmpty(radiusMetrics)) {
            return 0;
        }

        long runningLatency = 0;

        for (RadiusMetrics metrics : radiusMetrics) {
        	if(metrics.getLatencyMs() == null) {
        		continue;
        	}
            runningLatency += metrics.getLatencyMs().getAvgValue();
        }

        return runningLatency / radiusMetrics.size();
    }

    public static long getMaxRadiusLatency(List<RadiusMetrics> radiusMetrics) {
        if(radiusMetrics==null || radiusMetrics.isEmpty()){
            return 0;
        } 
         
        long maxLatency = 0;
        
        for(RadiusMetrics metrics : radiusMetrics)
        {
        	if(metrics.getLatencyMs() == null) {
        		continue;
        	}
        	
           if (metrics.getLatencyMs().getMaxValue()>maxLatency){
               maxLatency = metrics.getLatencyMs().getMaxValue(); 
           }
        }
        
        return maxLatency;
    }

    public static long getMinRadiusLatency(List<RadiusMetrics> radiusMetrics) {
        if(radiusMetrics==null || radiusMetrics.isEmpty()){
            return 0;
        } 
         
        long minLatency = Long.MAX_VALUE;
        
        for(RadiusMetrics metrics : radiusMetrics)
        {
        	if(metrics.getLatencyMs() == null) {
        		continue;
        	}
        	
           if (metrics.getLatencyMs().getMinValue()<minLatency){
               minLatency = metrics.getLatencyMs().getMinValue(); 
           }
        }
        
        return minLatency;
    }

}
