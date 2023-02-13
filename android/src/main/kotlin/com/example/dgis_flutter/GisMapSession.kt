package com.example.gis_native

import android.annotation.SuppressLint
import ru.dgis.sdk.map.MapView

object GisMapSession {
    @SuppressLint("StaticFieldLeak")
    private var  mapView : MapView? = null;

    @JvmStatic
    fun setMapView(view: MapView){
        mapView = view
    }

    @JvmStatic
    fun getMapView(): MapView? {
        return mapView;
    }
}