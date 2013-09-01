var map
var mapLocation
var prev_marker
var markers = new Array();
var infoBox = null;
var areaPicker = null;
var markerClusterer = null;
var infoWindow = new google.maps.InfoWindow({ content: '' });

var testCoords = { "nw_lat": 41.574361, "nw_lng": -125.533448, "se_lat": 32.750323, "se_lng": -114.744873}

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
                showMarkerClusterer();
            }
        } );
    }		
	var map_for_location_page = document.getElementById("map_for_location_page");
    if (map_for_location_page != null){
        params = get_url_parameters()
        initialize_map_for_location_page(map_for_location_page, params['lat'], params['lng']);
        content = create_study_location_content(params['lat'], params['lng'])
        placeLocationMarker(content, params['lat'], params['lng']);
    }

    var switcherControlDiv = document.createElement('div');
    var switcherControl = new OverlaySwitcher( map, switcherControlDiv );

    switcherControlDiv.index = 1;
    map.controls[ google.maps.ControlPosition.RIGHT_CENTER ].push( switcherControlDiv );

}

function initialize_map_for_landing_page(htmlElement) {
    var latlng = new google.maps.LatLng(0, 0);
    var myOptions = {
        zoom: 2,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(htmlElement, myOptions);
}

function initialize_map_for_location_page(htmlElement, lat, lng) {
    var latlng = new google.maps.LatLng(hash['lat'], hash['lng']);
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
       '<label class="label_lp" >Lat:</label> ' + lat + '<br/> <label class="label_lp" >Lng:</label> '+ lng +' <br/><br/> ' +
       '<a href="location?lat='+lat+'&lng='+lng+'" target="_NEW">' + 
       '<span >COUNT specimens</span></br>' +
       '</a><br/>' +
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
    var latlng = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({position: latlng, map: map});
    markers.push(marker);
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
      response = jQuery.ajax( { url:     '/location_count.txt?lat='+lat+'&lng='+lng+'',
                                success: function(result) {
                                           if(result.isOk == false)
                                              alert(result.message);
                                         },
                                async:   false } ); 
      infowindow.content = infowindow.content.replace("COUNT", response.responseText);
      infowindow.open(map, marker);
    });
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
    markerClusterer = new MarkerClusterer(map, markers, mcOptions);
}

function hideMarkerClusterer()
{
    markerClusterer.resetViewport( true );
}

function showMarkerClusterer()
{
    if ( markerClusterer === null ) {
        var mcOptions = {gridSize: 40, maxZoom: 0};
        markerClusterer = new MarkerClusterer(map, markers, mcOptions);
    }
    else
    {
        markerClusterer.redraw();
    }

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

function OverlaySwitcher( map, div) {
    var controlDiv = div,
        control = this;

    control.state_ = 'marker';
    controlDiv.style.margin = '3px';
    controlDiv.style.padding = '3px';
    controlDiv.style.backgroundColor = 'white';
    controlDiv.style.border = '1px solid #000';
    controlDiv.style.width = '35px';
    controlDiv.style.height = '21px';
    controlDiv.style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.4)';
    controlDiv.style.cursor = 'pointer';

    var switcherUI = document.createElement( 'div' );
    switcherUI.title = 'Show Area Picker';
    controlDiv.appendChild( switcherUI );

    var switcherText = document.createElement( 'div' )
    switcherText.innerHTML = '<img src="images/icon_area.png" />';
    switcherUI.appendChild( switcherText );

    google.maps.event.addDomListener( switcherUI, 'click', function() {
        switch ( control.state_ ) {
            case 'marker':
                control.state_ = 'rectangle';
                switcherUI.title = 'Show Markers';
                switcherText.innerHTML = '<img src="images/icon_marker.png" />';
                showRectControl();
                hideMarkerClusterer();

                break;
            case 'rectangle':
                control.state_ = 'marker'
                switcherUI.title = 'Show Area Picker';
                switcherText.innerHTML = '<img src="images/icon_area.png" />';
                hideRectControl();
                showMarkerClusterer();
                break;
        }

    } );
}

function hideRectControl() {
    areaPicker.setMap( null );
}

/**
 * Initialize rectangle area picker
 */
function showRectControl() {
    if ( areaPicker === null ) {
        var startBounds = new google.maps.LatLngBounds(
            new google.maps.LatLng( testCoords.se_lat, testCoords.nw_lng ), // California
            new google.maps.LatLng( testCoords.nw_lat, testCoords.se_lng )
        );

        areaPicker = new google.maps.Rectangle( {
            bounds: startBounds,
            editable: true
        } );

        showSpatialInfoBox( startBounds );


        areaPicker.setMap( map );

        google.maps.event.addListener( areaPicker, 'bounds_changed', function() {
            var newBounds = areaPicker.getBounds();
            showSpatialInfoBox( newBounds );

        } );
    }
    areaPicker.setMap( map );
}

/**
 * @param {google.maps.LatLngBounds} bounds
 */
function showSpatialInfoBox( bounds )
{
    infoWindow.close();

    infoWindow.setContent( getSpatialInfoBoxContentString( bounds ) );
    infoWindow.setPosition( bounds.getCenter() );
    infoWindow.open(map);
}

/**
 * @param {google.maps.LatLngBounds} bounds
 */
function getSpatialInfoBoxContentString( bounds )
{
    bounds = bounds.toEolCoords();
    return '<div>'+
        '<a target="_blank" href="interactions?'
        + 'nw_lat=' + bounds.nw_lat
        + '&nw_lng=' + bounds.nw_lng
        + '&se_lat=' + bounds.se_lat
        + '&se_lng=' + bounds.se_lng
        +'"><span>show interactions</span></br>' +
        '</a><br/>' +
        '</div>';
}

google.maps.LatLngBounds.prototype.toEolCoords = function()
{
    return {
        nw_lat: this.getNorthEast().lat(),
        nw_lng: this.getSouthWest().lng(),
        se_lat: this.getSouthWest().lat(),
        se_lng: this.getNorthEast().lng()
    }
};

/**
 *
 * @param {Object} eolCoords
 * @param {String} eolCoords.nw_lat
 * @param {String} eolCoords.nw_lng
 * @param {String} eolCoords.se_lat
 * @param {String} eolCoords.se_lng
 * @return {google.maps.LatLngBounds}
 */
google.maps.LatLngBounds.prototype.fromEolCoords = function( eolCoords )
{
    var sw = new google.maps.LatLng( eolCoords.se_lat, eolCoords.nw_lng );
    var ne = new google.maps.LatLng( eolCoords.nw_lat, eolCoords.se_lng );
    return new google.maps.LatLngBounds( sw, ne );
};
