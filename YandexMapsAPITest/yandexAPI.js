
var myMap

function parseGetParams() {
	var $_GET = {};
	var __GET = window.location.search.substring(1).split("&");
	for(var i=0; i<__GET.length; i++) {
		var getVar = __GET[i].split("=");
		$_GET[getVar[0]] = typeof(getVar[1])=="undefined" ? "" : getVar[1];
	}
	return $_GET;
}

function init () {
	
	var multiRoute = null
	
	var queryStr = parseGetParams()
	
	if (queryStr["longitudeA"] != null &&
		queryStr["longitudeB"] != null &&
		queryStr["latitudeA"] != null &&
		queryStr["latitudeB"] != null
		) {
		
		/**
		 * Создаем мультимаршрут.
		 * Первым аргументом передаем модель либо объект описания модели.
		 * Вторым аргументом передаем опции отображения мультимаршрута.
		 * @see https://api.yandex.ru/maps/doc/jsapi/2.1/ref/reference/multiRouter.MultiRoute.xml
		 * @see https://api.yandex.ru/maps/doc/jsapi/2.1/ref/reference/multiRouter.MultiRouteModel.xml
		 */
		var multiRoute = new ymaps.multiRouter.MultiRoute({
														  // Описание опорных точек мультимаршрута.
														  referencePoints: [
																			[queryStr["latitudeA"], queryStr["longitudeA"]],
																			[queryStr["latitudeB"], queryStr["longitudeB"]]
																			],
														  // Параметры маршрутизации.
														  params: {
														  // Ограничение на максимальное количество маршрутов, возвращаемое маршрутизатором.
														  results: 2
														  }
														  }, {
														  // Автоматически устанавливать границы карты так, чтобы маршрут был виден целиком.
														  boundsAutoApply: true
														  });
		
	}
	
	if (queryStr["crntLongitude"] != null && queryStr["crntLatitude"] != null) {
		var currentLocation = [queryStr["crntLongitude"], queryStr["crntLatitude"]]
	} else {
		var currentLocation = null
	}
	
	// Создаем карту с добавленными на нее кнопками.
	myMap = new ymaps.Map('map',
							  {
							  center: currentLocation != null ? currentLocation : [55.745508, 37.435225],
//							  center: [ymaps.geolocation.latitude, ymaps.geolocation.longitude],
							  zoom: 7,
							  controls: []
							  }
							  ,
							  {
							  buttonMaxWidth: 300
							  });
	
	if (multiRoute != null) {
		myMap.geoObjects.add(multiRoute);
	}
	
}

function setCenter(longitude, latitude) {
	myMap.setCenter(longitude,latitude)
}
