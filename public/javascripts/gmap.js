
var map
var prev_marker
var markers = new Array();

// ***** INIT MAP START ********************************

function initialize() {
    var map_for_landing_page = document.getElementById("map_for_landing_page");
    if (map_for_landing_page != null){
        initialize_map_for_landing_page(map_for_landing_page);
    }
}

function initialize_map_for_landing_page(htmlElement) {
    var latlng = new google.maps.LatLng(20.0, -15.4666667);
    var myOptions = {
        zoom: 2,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(htmlElement, myOptions);
}

// ***** INIT MAP STOP ********************************

function create_study_content(name, status, link){
    var contentString = '<div id="content">'+
       '<span>' + name + '</span><br/>' +
       '<span class="timestamp">Status: '+ status +'</span> | ' +
       '<span class="timestamp"><a href="'+link+'" target="_NEW">details</a></span><br/>' +
       '<br/><br/></div>';
    return contentString;
}

function placeMarker(contentString, lat, lng){
    var latlng = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({position: latlng, map: map});
    markers.push(marker);
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
}

function placeManualMarker(location) {
    if (prev_marker){
        prev_marker.setMap(null)
        prev_marker = null;
    }
    var marker = new google.maps.Marker({
        position: location,
        map: map
    });
    map.setCenter(location);
    prev_marker = marker;

    document.getElementById("ShowLatLon").style.display = "block";
    document.getElementById("show_lat").value = location.lat();
    document.getElementById("show_lon").value = location.lng();
    document.getElementById("measurement_lat").value = location.lat();
    document.getElementById("measurement_lon").value = location.lng();
}


// ***** FOR CLUSTERING ********************************

function clusterMarker(){
    var mcOptions = {gridSize: 40, maxZoom: 0};
    new MarkerClusterer(map, markers, mcOptions);
}

function fitMarkers(){
    if(markers.size == 1){
        map.setCenter(markers.getPosition());
    } else {
        var swLat = 90;
        var swLng = 180;
        var neLat = -90;
        var neLng = -180;

        for(var i in markers){
            var marker = markers[i];
            if (marker == null)
                continue
            var latLng = marker.position;
            if (latLng == null)
                continue
            var lat = latLng.lat;
            var lng = latLng.lng;

            if(lat < swLat)
                swLat = lat;
            if(lat > neLat)
                neLat = lat;
            if(lng < swLng)
                swLng = lng;
            if(lng > neLng)
                neLng = lng;
        }
        map.fitBounds(new google.maps.LatLngBounds(
            new google.maps.LatLng(swLat,swLng),
            new google.maps.LatLng(neLat,neLng))
        );
    }
}
