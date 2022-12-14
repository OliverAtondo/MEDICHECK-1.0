//
//  Service.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 10/12/22.
//

import Foundation
import SocketIO
import zlib

class Service: ObservableObject{
    @Published var manager = SocketManager(socketURL: URL(string: "http://34.125.255.24:5001")!, config: [.log(true), .compress, .version(.two)])
    
    @Published var messages = [String]()
    
    init(){
        let socket = manager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Connected")
            DispatchQueue.main.async {
                socket.emit("telemetria","ConexionE")
            }
        }
    }
    func sendAlert(coordinates: [String:String]){
        let socket = manager.defaultSocket
        
        socket.emit("telemetria", coordinates)
        print("SeActivo")
    }
}
