mapboxgl.accessToken = 'pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg';
let map = new mapboxgl.Map({
  container: 'locoMap',
  style: 'mapbox://styles/prettygoodstudios/cjiwl3mup71c72rmsfn9xeupa',
});
fetch(`${ROOT_URL}geoapi`).then((data) => {
  return(data.json());
}).then((data) => {
  data.forEach((l) => {
    let el = document.createElement('div');
    el.className = 'marker';
    el.innerHTML = (l.encounters != 1) ? `<div class="marker-alert">${l.encounters}</div>` : '';
    let marker = new mapboxgl.Marker(el,{ offset: [0, -35] }).setLngLat([l.longitude,l.latitude]).addTo(map);
    let title = `<h3>${l.city}</h3>`;
    let address = `<p>${l.full_address}</p>`;
    let link = `<a href="${ROOT_URL}location/${l.id}" class="green-button">View</a>`;
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

let observer = new MutationObserver((mutations, me) => {
  let mapContainer = document.querySelector(".mapboxgl-canvas-container");
  if(mapContainer){
    map.flyTo({center: [LOCATION[1],LOCATION[0]], zoom: ZOOM});
    //MutationObserver.disconnect();
    return;
  }
});

observer.observe(document, {
  childList: true,
  subtree: true
});
