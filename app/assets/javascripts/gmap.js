
var map
var mapLocation
var prev_marker
var markers = new Array();

// ***** INIT MAP START ********************************

function initialize() {
    var map_for_landing_page = document.getElementById("map_for_landing_page");
    if (map_for_landing_page != null){
        initialize_map_for_landing_page(map_for_landing_page);
		
        jQuery.ajax({
            url: window.location + "locations.json"
        }).done(function (data){
            if (data){
                for (var k in data){ 
                    dat = data[k]
                    latitude = dat['latitude']
                    longitude = dat['longitude']
                    count = dat['loc_count']
                    content = create_location_content(latitude, longitude, count, "link");
                    placeMarker(content, latitude, longitude);
                }
                clusterMarker();
            }
        } );
    }		
	var map_for_location_page = document.getElementById("map_for_location_page");
    if (map_for_location_page != null){
        params = get_url_parameters()
        initialize_map_for_location_page(map_for_location_page, params['lat'], params['lon']);
        content = create_study_location_content(params['lat'], params['lon'])
        placeLocationMarker(content, params['lat'], params['lon']);
    }	
}

function initialize_map_for_landing_page(htmlElement) {
    var latlng = new google.maps.LatLng(25.0, -90.4666667);
    var myOptions = {
        zoom: 6,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(htmlElement, myOptions);
}

function initialize_map_for_location_page(htmlElement, lat, lon) {
    var latlng = new google.maps.LatLng(hash['lat'], hash['lon']);
    var myOptions = {
        zoom: 5,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    mapLocation = new google.maps.Map(htmlElement, myOptions);
}

function get_url_parameters(){
    query = window.location.search.substring(1)
    vars = query.split("&");
    hash = new Array()
    for (var i=0;i<vars.length;i++) {
        var pair = vars[i].split("=");
        hash[pair[0]] = pair[1]
    }
    return hash
}

// ***** INIT MAP STOP ********************************

function create_location_content(lat, lng, count, link){
    var contentString = '<div id="mapcontent" class="mapcontent">'+
       '<label class="label_lp" >Lat:</label> ' + lat + '<br/> <label class="label_lp" >Lng:</label> '+ lng +' <br/> ' +
       '<a href="location?lat='+lat+'&lon='+lng+'" target="_NEW">details</a><br/>' +
       '</div>';
    return contentString;
}

function create_study_location_content(lat, lng){
    var contentString = '<div id="mapcontent" class="mapcontent">'+
       '<label >Lat:</label> '+ lat +' <br/> ' +
       '<label >Lng:</label> '+ lng +' <br/> ' +
       '</div>';
    return contentString;
}

function placeMarker(contentString, lat, lng){
    // alert(contentString)
    // alert(lat)
    // alert(lng)
    var latlng = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({position: latlng, map: map});
    // alert(marker)
    markers.push(marker);
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
    // alert("end")
}

function placeLocationMarker(contentString, lat, lng){	
    var latlng = new google.maps.LatLng(lat, lng);	
    var marker = new google.maps.Marker({position: latlng, map: mapLocation});
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(mapLocation, marker);
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
