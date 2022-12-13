import express from "express"
import Alexa, { SkillBuilders } from 'ask-sdk-core';
import morgan from "morgan";
import { ExpressAdapter } from 'ask-sdk-express-adapter';
import NodeMailer from 'nodemailer';
import {io} from "socket.io-client";

const app = express ();
app.use(morgan("dev"));
const PORT = process. env. PORT || 3000;

var socket;

const LaunchRequestHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'LaunchRequest';
    },
    handle(handlerInput) {
        const speakOutput = 'LLAMANDO A EMERGENCIAS. HE ENVIADO UN CORREO DE ALERTA A TU CONTACTO DE CONFIANZA';

        socket = io("http://34.125.255.24:5001", {"forceNew": true,
        query: {
            alexa: 1,
            latitude: 32.535391,
            longitude: -116.927633,
            patientName: "Ivan Lorenzana"
        }});
        socket.disconnect();

        var transporter = NodeMailer.createTransport({
            service: 'Gmail',
            auth: {
              user: 'authorizedmailer@gmail.com',
              pass: 'xazhqaazawegdfcm',
            }
          });

          var mailOptions = {
            from: 'authorizedmailer@gmail.com',
            to: 'ivan.lorenzana193@tectijuana.edu.mx',
            subject: 'ALERTA',
            html: '<h1>ALERTA</h1><p>Una persona está en peligro.</p>'
          }
          
          transporter.sendMail(mailOptions, function(error, info){
            if (error) {
              console.log(error);
            } else {
              console.log('Email sent: ' + info.response);
            }
          });

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .getResponse();
    }
};

const ErrorHandler = {
    canHandle() {
        return true;
    },
    handle(handlerInput, error) {
        const speakOutput = 'Sorry, I had trouble doing what you asked. Please try again.';
        console.log(`~~~~ Error handled: ${JSON.stringify(error)}`);

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};


const skillBuilder = SkillBuilders.custom ()
.addRequestHandlers(
LaunchRequestHandler)
.addErrorHandlers(
ErrorHandler
)

const skill = skillBuilder.create();
const adapter = new ExpressAdapter(skill, false, false);

app.post('/api/v1/webhook-alexa', adapter.getRequestHandlers());

app.use(express.json())

app.listen (PORT, () => {
    console.log(`server is running on port ${ PORT }`);
});