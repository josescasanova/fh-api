//       _____    ____   ____      _____        _____    ____  _________________       _____    
//  ___|\     \  |    | |    | ___|\    \   ___|\    \  |    |/                 \ ____|\    \   
// |    |\     \ |    | |    ||    |\    \ |    |\    \ |    |\______     ______//     /\    \  
// |    | |     ||    | |    ||    | |    ||    | |    ||    |   \( /    /  )/  /     /  \    \ 
// |    | /_ _ / |    | |    ||    |/____/ |    |/____/ |    |    ' |   |   '  |     |    |    |
// |    |\    \  |    | |    ||    |\    \ |    |\    \ |    |      |   |      |     |    |    |
// |    | |    | |    | |    ||    | |    ||    | |    ||    |     /   //      |\     \  /    /|
// |____|/____/| |\___\_|____||____| |____||____| |____||____|    /___//       | \_____\/____/ |
// |    /     || | |    |    ||    | |    ||    | |    ||    |   |`   |         \ |    ||    | /
// |____|_____|/  \|____|____||____| |____||____| |____||____|   |____|          \|____||____|/ 
//   \(    )/        \(   )/    \(     )/    \(     )/    \(       \(               \(    )/    
//    '    '          '   '      '     '      '     '      '        '                '    '     
                                                                                             


'use strict';

angular.module('burritoApp').controller('MainCtrl', ['$scope', '$http', '$timeout', function ($scope, $http, $timeout) {

	var map, lat, lon, latlon, pick_up_marker, drop_off_marker, markerBounds;
	
	$scope.pickupLocation = "loading...";
	$scope.dropoffLocation;
	
	$scope.dropoffSearch;
	
	$scope.pickup_is_set = false;
	$scope.dropoff_is_set = false;

	$scope.contact_name = "";
	$scope.contact_number = "";

	$scope.submit_request_button = "Send Car Request";

	$scope.rate = 3.5;
	$scope.cost_estimate = 0;

	var geocoder = new google.maps.Geocoder();
	var directionsService = new google.maps.DirectionsService();
	var directionsDisplay;

	
	// Check to see if we're logged in.
    $http({ url: SITE_ROOT + '/api-call', method: 'POST',
	    data: { _method: "POST", _url: API_HOST + "/api/v1/echo", "fred": "flintstone" }
  	}).success(function( data ) {
	    if( data.status == 'not logged in' ) {
		  	window.location.href = "/login";
		  	return;
	    }
	});

	// Gets user location
    if('geolocation' in navigator) {
        navigator.geolocation.getCurrentPosition(function(position) {
            lat = position.coords.latitude;
            lon = position.coords.longitude;
            latlon = position.coords.latitude + "," + position.coords.longitude;
            
			initBurritoMap();
        }, function(error) {
            console.log(error)
        });
    }

    $scope.setPickup = function() {
		$scope.pickup_is_set = true;
		setTimeout(function(){ $('#dropoff-search').find('input').focus()}, 0);
	}
	
	$scope.setDropoff = function() {
		setMapBounds();
		$scope.dropoff_is_set = true;
	}

	$scope.searchMap = function(scope, type) {
		geocoder.geocode({'address': scope}, function(data, status) {
			if (status === google.maps.GeocoderStatus.OK) { 
				lat = data[0].geometry.location.lat();
				lon = data[0].geometry.location.lng();
				
				// SET PICKUP MARKER
				if (type === 'pickup') {
					$scope.pickupLocation = data[0].formatted_address;
					$scope.$apply();
					
					placePickupMarker(lat, lon)
					map.panTo(pick_up_marker.getPosition());
				
				// SET DROPOFF MARKER
				} else {
					$scope.dropoffLocation = data[0].formatted_address;
					$scope.dropoff_pin_dropped = true;
					$scope.$apply();
					
					placeDropoffMarker(lat, lon)
					map.panTo(drop_off_marker.getPosition());
					
					setTimeout(function(){$('#dropoff-search').find('input[ng-model="dropoffLocation"]').blur()}, 0);
				}
			}
		});
	}

	$scope.showFinalStep = function() {
		$scope.show_contact_info = true;
		setTimeout(function(){$('input[ng-model="contact_name"]').focus()}, 0);
	}

	$scope.sendRequest = function() {
	    console.log('Sending this request to Fancy Hands!!');
	    $scope.submit_request_button = "Sending..."

	    // Set expiration date
	    var expiration_date = new Date();
		expiration_date.setTime(expiration_date.getTime() + (24 * 60 * 60 * 1000)); // this makes it 24 hours from now

		// Set main description text
		var description = 'Call a nearby car service and have them pick me up at ' + $scope.pickupLocation + ' and drop me off at ' + $scope.dropoffLocation + '.\n\n' +
						   'My name: ' + $scope.contact_name + '\n' +
						   'My number: ' + $scope.contact_number + '\n\n' + 'Thanks!';

	    var post_data = {
    		_method: "POST",
    		_url: API_HOST + "/api/v1/request/custom/",
			title: 'Car Pickup',
			description: description,
			bid: 4,
			expiration_date: expiration_date,
		};
	    
	    $http({ 
	    	url: SITE_ROOT + '/api-call', 
		    method: 'POST', 
		    data: post_data 
		})
		.success(function(data) {
	        console.log(data);
	        $scope.submit_request_button = "Sent!";

	        // TODO: show some sort of success page
		})
		.error(function(error) {
			console.log(error);
			$scope.submit_request_button = "There was a problem :("; 
		})

	}
	
	// GOOGLE MAP
    // =============================================================================
	function initBurritoMap() {
	  	var mapOptions = {
	    	zoom: 18,
	    	center: new google.maps.LatLng(lat, lon),
	    	mapTypeId: google.maps.MapTypeId.ROADMAP,
	    	mapTypeControl: false,
	    	streetViewControl: false,
		};
	  	map = new google.maps.Map(document.getElementById('burrito-map'), mapOptions);
	  	placePickupMarker(lat, lon);
	    geocodePosition(pick_up_marker, pick_up_marker.getPosition());

	  	directionsDisplay = new google.maps.DirectionsRenderer({
			suppressMarkers: true,
			preserveViewport: true
		});
	}

	function placePickupMarker(lat, lon) {
	        pick_up_marker ? pick_up_marker.setMap(null) : "";
	        latlon = new google.maps.LatLng(lat, lon);
	        pick_up_marker = new google.maps.Marker({
	        position: latlon,
	        draggable:true,
	    		animation: google.maps.Animation.DROP,
	        map: map
	    });
	    if ($scope.pickup_is_set) setDirections();
	    watchMarkerPosition(pick_up_marker);
    }

	function placeDropoffMarker(lat, lon) {
		drop_off_marker ? drop_off_marker.setMap(null) : drop_off_marker = "";
		drop_off_marker = new google.maps.Marker({
	        position: new google.maps.LatLng(lat, lon),
	        draggable:true,
	    	animation: google.maps.Animation.DROP,
	        map: map,
	        icon: '/img/map-pin.png',
	    });
	    
	    watchMarkerPosition(drop_off_marker);
	    setDirections();
	}

	// Handler for when marker is dragged and dropped
	function watchMarkerPosition(marker) {
		google.maps.event.addListener(marker, 'dragend', function() {
		    geocodePosition(marker, marker.getPosition());
			map.panTo(marker.getPosition());
			if (marker === drop_off_marker) setDirections();
		});	
	}

	// Gets address at marker (used for dragging and init)
	function geocodePosition(marker, pos) {
	    geocoder.geocode({ latLng: pos }, function(results, status) {
	        if (status == google.maps.GeocoderStatus.OK) {
	            if (marker === drop_off_marker) {
	            	$scope.dropoffLocation = results[0].formatted_address;
	            } else {
		            $scope.pickupLocation = results[0].formatted_address;
	            }
	            $scope.$apply();
	        } 
	        else {
	            console.log('Cannot determine address at this location.' + status);
	        }
	    });
	}

	function setMapBounds() {
		markerBounds = new google.maps.LatLngBounds();
		markerBounds.extend(drop_off_marker.getPosition());
		markerBounds.extend(pick_up_marker.getPosition());
		map.fitBounds(markerBounds)
	}

	function setDirections() {
		directionsDisplay.setMap(null);
		var directionsRequest = {
		  	origin: pick_up_marker.getPosition(),
		  	destination: drop_off_marker.getPosition(),
		  	travelMode: google.maps.DirectionsTravelMode.DRIVING,
		  	unitSystem: google.maps.UnitSystem.IMPERIAL
		};
		directionsService.route(directionsRequest, function(response, status) {
			if (status == google.maps.DirectionsStatus.OK) {
			    
			    $scope.distance = response.routes[0].legs[0].distance.text;
			    
			    // value from the response is returned in meters, divided by meters in mile, multiplied by our rate per mile, rounded up
			    $scope.cost_estimate = Math.ceil((response.routes[0].legs[0].distance.value / 1609.34 ) * $scope.rate); 
			    $scope.$apply();
			    directionsDisplay.setMap(map);
			    directionsDisplay.setDirections(response);
			}
		})
	}

}]);
