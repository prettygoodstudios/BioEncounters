mapboxgl.accessToken="pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg";let map=new mapboxgl.Map({container:"map",style:"mapbox://styles/prettygoodstudios/cjiwl3mup71c72rmsfn9xeupa"}),nav=new mapboxgl.NavigationControl;map.addControl(nav,"top-left"),fetch(`${ROOT_URL}geoapi`).then(e=>e.json()).then(e=>{e.forEach(e=>{let a=document.createElement("div");a.className="marker",a.innerHTML=1!=e.encounters?`<div class="marker-alert">${e.encounters}</div>`:"";let t=new mapboxgl.Marker(a,{offset:[0,-35]}).setLngLat([e.longitude,e.latitude]).addTo(map),o=`<h3>${e.city}</h3>`,n=`<p>${e.full_address}</p>`,l=`<a href="${ROOT_URL}location/${e.slug}" class="green-button">View</a>`,p=(new mapboxgl.Popup).setHTML(o+n+l);t.setPopup(p)})});