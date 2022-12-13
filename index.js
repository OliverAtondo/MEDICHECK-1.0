var express = require('express');
var app = express();
var server = require('http').Server(app);
const io = require('socket.io')(server);
var nodemailer = require('nodemailer');

app.use(express.static('public'));

io.on('connection', function (socket) {
  console.log('Nueva Dispositivo Conectado');
  socket.on('telemetria', function(data)
  {
    console.log(data);
    io.emit('telemetria', data);
  });

});

server.listen(3001, function(){
    console.log("Servidor corriendo en el puerto 5001.")
});

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'authorizedMailer@gmail.com',
    pass: 'Pedro1234'
  }
});

var mailOptions = {
  from: 'authorizedMailer@gmail.com',
  to: 'oliver.atondo193@tectijuana.edu.mx',
  subject: 'ALERTA',
  html: '<h1>Welcome</h1><p>That was easy!</p>'
}

transporter.sendMail(mailOptions, function(error, info){
  if (error) {
    console.log(error);
  } else {
    console.log('Email sent: ' + info.response);
  }
});