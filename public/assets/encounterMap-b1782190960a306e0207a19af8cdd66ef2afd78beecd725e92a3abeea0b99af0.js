mapboxgl.accessToken = 'pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg';
let map = new mapboxgl.Map({
  container: 'encounterMap',
  style: 'mapbox://styles/prettygoodstudios/cjiwl3mup71c72rmsfn9xeupa',
});
let nav = new mapboxgl.NavigationControl();
map.addControl(nav, 'top-left');
fetch(`${ROOT_URL}specie_geo_api?specie=${SPECIE_ID}`).then((data) => {
  return(data.json());
}).then((data) => {
  if(data.length > 0) map.flyTo({center: [data[0].longitude,data[0].latitude], zoom: 3});
  data.forEach((l) => {
    let el = document.createElement('div');
    el.className = 'marker';
    let marker = new mapboxgl.Marker(el,{ offset: [0, -35] }).setLngLat([l.longitude,l.latitude]).addTo(map);
    let title = `<h3>${l.city}</h3>`;
    let address = `<p>${l.full_address}</p>`;
    let link = `<a href="${ROOT_URL}location/${l.location_id}" class="green-button">View This Location</a>`;
    let popup = new mapboxgl.Popup().setHTML(title+address+link);
    marker.setPopup(popup);
  });
});
map.on('style.load', function () {
  map.style.stylesheet.layers.forEach(function(layer) {
    if (layer.type === 'symbol') {
        map.removeLayer(layer.id);
    }
});
});
