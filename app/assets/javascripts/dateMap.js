mapboxgl.accessToken = 'pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg';
let map = new mapboxgl.Map({
  container: 'locoMap',
  style: 'mapbox://styles/prettygoodstudios/cjiwl3mup71c72rmsfn9xeupa',
  scrollZoom: (window.innerWidth > 900) ? true : false
});
let nav = new mapboxgl.NavigationControl();
map.addControl(nav, 'top-left');
fetch(`${ROOT_URL}${PATH}`).then((data) => {
  return(data.json());
}).then((data) => {
  let locations = [];
  data.forEach((e,i) => {
    let found = -1;
    locations.forEach((l,j) => {
      if(e.location_id == l.location_id) found = j;
    });
    if(found == -1){
      const temp = {
        location_id: e.location_id,
        latitude: e.latitude,
        longitude: e.longitude,
        city: e.city,
        encounters: [e]
      }
      locations.push(temp);
    }else{
      locations[found].encounters.push(e);
    }
  });
  console.log(locations);
  locations.forEach((l) => {
    let el = document.createElement('div');
    el.className = 'marker';
    el.innerHTML = (l.encounters.length != 1) ? `<div class="marker-alert">${l.encounters.length}</div>` : '';
    let marker = new mapboxgl.Marker(el,{ offset: [0, -35] }).setLngLat([l.longitude,l.latitude]).addTo(map);
    const title = `<h3>${l.city}</h3>`;
    const description = `<p>${l.encounters.length} Encounter${ l.encounters.length != 1 ? 's' : ''}</p>`
    const encounters = l.encounters.map((e) => {
     return `<p><strong>${e.common}</strong> - <i>${e.description}</i></p>`;
    }).join("");
    const link = `<a href="${ROOT_URL}location/${l.location_id}" class="green-button">View More From This Location</a>`;
    const popup = new mapboxgl.Popup().setHTML(title+description+encounters+link);
    marker.setPopup(popup);
  });
  map.flyTo({center: [data[0].longitude,data[0].latitude], zoom: 6});
});
window.onresize = () => {
  console.log(map);
  if(window.innerWidth > 900){
    map.scrollZoom.enable();
  }else{
    map.scrollZoom.disable();
  }
}
