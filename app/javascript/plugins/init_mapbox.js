import mapboxgl from 'mapbox-gl';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
    let bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 100, maxZoom: 15, duration: 0 });

    map.on('moveend', (e) => {
      document.getElementById('adaptMapButton').classList.remove("inactive");
        const mapLngNe = map.getBounds().getNorthEast().lng; //valeur haute
        const mapLatNe = map.getBounds().getNorthEast().lat; //valeur haute
        const mapLngSw = map.getBounds().getSouthWest().lng; //valeur basse
        const mapLatSw = map.getBounds().getSouthWest().lat; //valeur basse
        document.getElementById('search_minlongitude_20').value = parseFloat(mapLngSw);
        document.getElementById('search_maxlongitude_20').value = parseFloat(mapLngNe);
        document.getElementById('search_minlatitude_20').value = parseFloat(mapLatSw);
        document.getElementById('search_maxlatitude_20').value = parseFloat(mapLatNe);
    });
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);

      new mapboxgl.Marker({ "color": "#52828D" })
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
    });

    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
