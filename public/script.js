var socket = io.connect('http://34.125.255.24:5001', {'forceNew':true});

var lati = 32.5;
var longi = -117;

var counter = 0;

socket.on('telemetria', function(data){
  console.log(data);
  longi = Number(data.longitude);
  lati = Number(data.latitude);
  var name = data.patientName;
  var marker = L.marker(
    [lati, longi],
    {
      draggable: false,
      title: "PRIORITY",
      opacity: 1
  });

  marker.addTo(map).bindPopup(`Aquí está ${name}`).openPopup();

  map.flyTo([lati, longi], 15);

  counter += 1;

  var number = counter;
  var xxx = lati;
  var yyy = longi;

//map.removeLayer(marker);

  document.getElementById("tareas").innerHTML += `<div id=${number} class="emer" onmouseover="map.flyTo([${xxx},${yyy}], 15);">EMERGENCY ON: (${lati},${longi}) <br>
  </button>
  <button class="custom-btn btn-5" onClick=myFunction(${number})><span> Task Solved </span></button></div>`;
});

function myFunction( id ){
  document.getElementById(id).remove();
}

var map = L.map('map', {
  center: [lati, longi],
  zoom: 11
});

var tiles = new L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    minZoom: '15'}).addTo(map);

socket.on('localaaaa', function(data){
      var marker = L.marker(
        [32.531095427205734, -116.98761564489558],
        {
          draggable: false,
          title: "PRIORITY",
          opacity: 1
      });
      marker.addTo(map).bindPopup(`INCENDIO`).openPopup();
      map.flyTo([32.531095427205734, -116.98761564489558], 15);

      counter += 1;
      var number = counter;
      var xxx = 32.531095427205734;
      var yyy = -116.98761564489558;

    //map.removeLayer(marker);

      document.getElementById("tareas").innerHTML += `<div id=${number} class="emer" onmouseover="map.flyTo([${xxx},${yyy}], 15);">EMERGENCY ON TOMAS AQUINO) <br>
      </button>
      <button class="custom-btn btn-5" onClick=myFunction(${number})><span> Task Solved </span></button></div>`;
    });