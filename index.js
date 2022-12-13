var express = require('express');
var app = express();
var server = require('http').Server(app);
const io = require('socket.io')(server);

app.use(express.static('public'));

io.on('connection', function (socket) {
  console.log('Nuevo Dispositivo Conectado');
  if (socket.handshake.query.alexa == true){
    io.emit('telemetria', socket.handshake.query);
    io.emit('desde_servidor', "ON");
  }
  socket.on('telemetria', function(data)
  {
    console.log(data);
    io.emit('telemetria', data);
  });
  socket.on('arduino', function(data)
  {
    if(data.text == "ALERT"){
      io.emit('desde_servidor', "ON");
      io.emit('localaaaa', "ON");
    }
  });
});

server.listen(5001, function(){
    console.log("Servidor corriendo en el puerto 5001.")
});