var map = null;
var geocoder = null;
var points = new Array();
var pathLine = null;
var metric = null;
var bournes = new Array();

function load() {
  if (GBrowserIsCompatible()) {
  	metric = false;
    map = new GMap2(document.getElementById("map"));
    map.addControl(new GSmallMapControl());
    map.setCenter(new GLatLng(41.850255517713805, -87.64995574951172), 13);
    geocoder = new GClientGeocoder();
    GEvent.addListener(map, "click", function(overlay, point) {
      addOrRemoveMarker(overlay, point);
    });
  }
}

function reload() {
	if (GBrowserIsCompatible()) {
  		metric = false;
    	map = new GMap2(document.getElementById("map"));
    	map.addControl(new GSmallMapControl());
    	map.setCenter(retrieveCenter(), 13);
    	geocoder = new GClientGeocoder();
    	recreatePathFromCSV(document.getElementById("coordinates").value);
    	pathLength(points);
	}
}

function centerOnAddress(point) {
	if (!point) {
		alert(address + " not found");
    } else {
    	map.setCenter(point, 13);
	}
}

function toggleMetric() {
	if (metric){
		metric = false;
	}else {
		metric = true;
	}
	pathLength(points);	
}

function recreatePathFromCSV(coords){
	var coordArray = coords.split(",");
	if (coordArray.length > 1){
		for (i=0;i<coordArray.length;i=i+2){
			mark = new GMarker(new GLatLng(coordArray[i], coordArray[i+1]));
			//map.addOverlay(mark);
    		addToPath(mark, points);
		}
		drawStartFinish();
	}
}

function addOrRemoveMarker(overlay, point){
	if (overlay) {
    	map.removeOverlay(overlay);
    	removeFromPath(overlay.getPoint(), points);
    	pathLength(points);
  	} else {
  		mark = new GMarker(point);
    	map.addOverlay(mark);
    	addToPath(mark, points);
    	pathLength(points);
  	}
}

function addToPath(marker, path){
	point = marker.getPoint();
    path.push(point);
    updatePathLine();
    document.course.coords.value =  escape(points.toString());
}

function removeFromPath(marker, path){
	var indexOfMarker = points.indexOf(marker);
	if (indexOfMarker > -1){
		points.splice(indexOfMarker,1);
		updatePathLine();
    }
    document.course.coords.value =  escape(points.toString());
}

function updatePathLine(){
	map.removeOverlay(pathLine);
	pathLine = new GPolyline(points);
	map.addOverlay(pathLine);
}

function pathLength(path) {
	var meters = 0;
	for(i=1;i<path.length;i++) {
		meters = meters + path[i-1].distanceFrom(path[i]);	
	}
	if (metric){
		document.course.distance.value = twoDecimals(meters);
		display("distance", twoDecimals(meters) + " meters");
	} else {
		document.course.distance.value = twoDecimals(meters);
		display("distance", twoDecimals(toMiles(meters)) + " miles");
	}
}

function showAddress(address) {
  if (geocoder) {
    geocoder.getLatLng(
      address, function(point) {
        centerOnAddress(point);
      }
    );
  }
}

function drawStartFinish(){
	map.addOverlay(new GMarker(points[0]));
	map.addOverlay(new GMarker(points[points.length - 1]));
}

function showDistanceMarkers(){
	var meters = 0;
	var interval = interval();
	
	for(i=1;i<path.length;i++) {
		meters = meters + path[i-1].distanceFrom(path[i]);
		if (meters > interval)
			addAPointToTheMarkersArrayForEveryIntervalOnThisLine(path[i-1], path[i], interval);	
	}
}

function interval() {
	var interval = 0;
	if (metric) {
		interval = 1000; // interval is 1 km
	} else {
		interval = toMeters(1); // interval is 1 mi.
	}
	return interval;
}

function toMiles(meters){
	return meters * 0.000621371192;
}

function toMeters(miles){
	return miles*(1/toMiles(1));
}

function twoDecimals(float) {
	return float.toFixed(2);
}

function display(id, value) {
	document.getElementById(id).innerHTML = value;
}

function metersBetweenTwoPoints(p1, p2) {
	p1 = map.fromDivPixelToLatLng(p1);
	p2 = map.fromDivPixelToLatLng(p2);
  	var R = 6371; // earth's mean radius in km
  	var dLat  = p2.lat() - p1.lat();
  	var dLong = p2.lon() - p1.lon();

  	var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.cos(p1.lat()) * Math.cos(p2.lat()) * Math.sin(dLong/2) * Math.sin(dLong/2);
  	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  	var d = R * c;

  	return d/1000;
}

function retrieveCenter(){
	var coordArray = document.getElementById("center").value.split(",");
	if (coordArray.length == 2){
		return new GLatLng(coordArray[0], coordArray[1])
	} else {
		return new GLatLng(41.850255517713805, -87.64995574951172)//chicago
	}
}