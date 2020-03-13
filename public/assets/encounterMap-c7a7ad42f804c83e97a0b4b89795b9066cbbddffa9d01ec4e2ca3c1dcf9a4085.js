mapboxgl.accessToken="pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg";let map=new mapboxgl.Map({container:"encounterMap",style:"mapbox://styles/prettygoodstudios/cjiwl3mup71c72rmsfn9xeupa"}),nav=new mapboxgl.NavigationControl;map.addControl(nav,"top-left"),fetch(`${ROOT_URL}specie_geo_api?specie=${SPECIE_ID}`).then(e=>e.json()).then(e=>{e.length>0&&map.flyTo({center:[e[0].longitude,e[0].latitude],zoom:3}),e.forEach(e=>{let a=document.createElement("div");a.className="marker";let t=new mapboxgl.Marker(a,{offset:[0,-35]}).setLngLat([e.longitude,e.latitude]).addTo(map),o=`<h3>${e.city}</h3>`,l=`<p>${e.full_address}</p>`,n=`<a href="${ROOT_URL}location/${e.slug}" class="green-button">View This Location</a>`,p=(new mapboxgl.Popup).setHTML(o+l+n);t.setPopup(p)})}),map.on("style.load",function(){map.style.stylesheet.layers.forEach(function(e){"symbol"===e.type&&map.removeLayer(e.id)})});