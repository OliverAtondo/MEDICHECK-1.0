//
//  MedicalRecord.swift
//  MedCheck
//
//  Created by Ivan Lorenzana Belli on 09/12/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct MedicalRecordView: View {
    @State var isEditing: Bool = false
    @State var isLoading: Bool = false
    @State var disposableDates: [Date] = [Date(),Date()]
    @State var disposableDoubles: [Double] = [0,0,0,0,0,0]
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    // MARK: App Storage
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("is_google_user") var isGoogleUser: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    // MARK: Personal Information Variables
    @State var patientName = ""
    @State var birthDate = ""
    @State var gender = ""
    @State var age = ""
    @State var maritalStatus = ""
    @State var address = ""
    @State var cellphoneNumber = ""
    // MARK: Family Health History
    @State var hasDiabetes: Bool = false
    @State var hasObesity: Bool = false
    @State var hasHeartDisease: Bool = false
    @State var hasHypertension: Bool = false
    @State var hasLungDisease: Bool = false
    @State var hasCancer: Bool = false
    // MARK: Personal Health 1
    @State var drinkingScale = "0.0"
    @State var smokingScale = "0.0"
    @State var fitnesScale = "0.0"
    @State var sleepingHours = "0.0"
    @State var workingStudingHours = "0.0"
    @State var allergies = ""
    // MARK: Personal Health 2
    @State var illness = ""
    @State var illnessDate = ""
    @State var treatment = ""
    @State var doseOfMedication = ""
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Text("Medical Record")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.biomedPrimary)
                        .padding(.bottom, -5)
                    Spacer()
                }
                Divider()
                    .padding(.horizontal,-20)
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading){
                        // MARK: Personal Information
                        personalInfo
                        // MARK: Family Health History
                        familyHealth
                        // MARK: Personal Health History non Patologic
                        nonPatologic
                        // MARK: Personal Health History Patologic
                        patologic
                        HStack{
                            Spacer()
                            Button(action: {
                                let medicalRecord = MedicalRecord(userUID: userUID, patientName: patientName, birthDate: birthDate, gender: gender, age: age, maritalStatus: maritalStatus, address: address, cellphoneNumber: cellphoneNumber, hasDiabetes: hasDiabetes, hasObesity: hasObesity, hasHeartDisease: hasHeartDisease, hasHypertension: hasHypertension, hasLungDisease: hasLungDisease, hasCancer: hasCancer, drinkingScale: drinkingScale, smokingScale: smokingScale, fitnesScale: fitnesScale, sleepingHours: sleepingHours, workingStudingHours: workingStudingHours, allergies: allergies, illness: illness, illnessDate: illnessDate, treatment: treatment, doseOfMedication: doseOfMedication)
                                sendObjectToFireStore()
                            }){
                                Text("Enviar datos")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-50)
                                    .disableWithOpacity(patientName == "" || birthDate == "" || gender == "" || age == "" || maritalStatus == "" || address == "" || cellphoneNumber == "" || drinkingScale == "" || smokingScale == "" || fitnesScale == "" || sleepingHours == "" || workingStudingHours == "" || allergies == "" || illness == "" || illnessDate == "" || treatment == "" || doseOfMedication == "")
                            }
                            .background(Color.biomedPrimary)
                            .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
    }
    var personalInfo: some View{
        Group{
            Text("1. Personal Information")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            TextField("Full Name", text: self.$patientName)
                .textFieldStyle(.roundedBorder)
            TextField("Address", text: self.$address)
                .textFieldStyle(.roundedBorder)
            TextField("Enter your phone number", text: self.$cellphoneNumber, onEditingChanged: { isEditing in
                self.isEditing = isEditing
            })
            .keyboardType(.phonePad)
            .foregroundColor(isEditing && !cellphoneNumber.isValidPhoneNumber() ? Color.biomedPrimary : .black)
            .textFieldStyle(.roundedBorder)
            // MARK: Picker Area
            VStack(alignment: .leading){
                HStack(spacing: 12){
                    Text("Gender")
                        .fontWeight(.bold)
                    Spacer()
                    Picker(selection: self.$gender, label: Text("Gender")){
                        Text("Female").tag("Female")
                        Text("Male").tag("Male")
                    }
                    .tint(Color.biomedPrimary)
                    .frame(minWidth: 0)
                    .pickerStyle(.menu)
                    .border(0.2, .gray)
                }
                HStack(spacing: 12){
                    Text("Marital Status")
                        .fontWeight(.bold)
                    Spacer()
                    Picker(selection: self.$maritalStatus, label: Text("MaritalStatus")) {
                        Text("Single").tag("Single")
                        Text("Married").tag("Married")
                        Text("Divorced").tag("Divorced")
                        Text("Widowed").tag("Widowed")
                    }
                    .tint(Color.biomedPrimary)
                    .frame(minWidth: 0)
                    .border(0.2, .gray)
                }
                HStack(spacing: 12){
                    Text("Age")
                        .fontWeight(.bold)
                    Spacer()
                    Picker("Age", selection: self.$age){
                        ForEach(18...99, id: \.self){
                            i in Text("\(i)").tag("\(i)")
                        }
                    }
                    .tint(Color.biomedPrimary)
                    .frame(minWidth:0)
                    .border(0.2, .gray)
                    
                }
                DatePicker("Date of Birth", selection: $disposableDates[0], in: ...Date.now, displayedComponents: .date)
                    .onChange(of: disposableDates[0], perform: { date in
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        self.birthDate = formatter.string(from: disposableDates[0])
                    })
                    .fontWeight(.bold)
                    .tint(Color.biomedPrimary)
            }
            .border(0.2, .gray)
        }
    }
    var familyHealth: some View{
        Group{
            Text("2. Family Health History")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            VStack{
                Toggle("Mellitus Diabetes", isOn: self.$hasDiabetes)
                Toggle("Obesity", isOn: self.$hasObesity)
                Toggle("Heart Disease", isOn: self.$hasHeartDisease)
                Toggle("Arterial Hypertension", isOn: self.$hasHypertension)
                Toggle("Cancer", isOn: self.$hasCancer)
                Toggle("Lung Disease", isOn: self.$hasLungDisease)
            }
            .border(0.2, .gray)
            .frame(minWidth: 0)
        }
    }
    var nonPatologic: some View{
        Group{
           Text("3. Non-Pathological Personal Background ")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            VStack(alignment: .leading){
                Group{
                    Text("Smoking Scale")
                        .bold()
                    HStack{
                        Slider(value: self.$disposableDoubles[0], in: 0...10, step:1)
                            .onChange(of: self.disposableDoubles[0]) { disposableDouble in
                                self.smokingScale = "\(disposableDoubles[0])"
                            }
                        Text("\(smokingScale)")
                    }
                    Text("Drinking Scale")
                        .bold()
                    HStack{
                        Slider(value: self.$disposableDoubles[1], in: 0...10, step:1)
                            .onChange(of: self.disposableDoubles[1]) { disposableDouble in
                                self.drinkingScale = "\(disposableDoubles[1])"
                            }
                        Text("\(drinkingScale)")
                    }
                    Text("Daily hours of physical activity")
                        .bold()
                    HStack{
                        Slider(value: self.$disposableDoubles[2], in: 0...6, step:1)
                            .onChange(of: self.disposableDoubles[2]) { disposableDouble in
                                self.fitnesScale = "\(disposableDoubles[2])"
                            }
                        Text("\(fitnesScale)")
                    }
                    Text("Daily Hours of Sleep")
                        .bold()
                    HStack{
                        Slider(value: self.$disposableDoubles[3], in: 0...12, step:1)
                            .onChange(of: self.disposableDoubles[3]) { disposableDouble in
                                self.sleepingHours = "\(disposableDoubles[3])"
                            }
                        Text("\(sleepingHours)")
                    }
                    Text("Hours dedicated to Work or Study")
                        .bold()
                    HStack{
                        Slider(value: self.$disposableDoubles[4], in: 0...12, step:1)
                            .onChange(of: self.disposableDoubles[4]) { disposableDouble in
                                self.workingStudingHours = "\(disposableDoubles[4])"
                            }
                        Text("\(workingStudingHours)")
                    }
                }
            }
            .border(0.2, .gray)
            TextField("Allergies in General", text: self.$allergies)
                .textFieldStyle(.roundedBorder)
        }
    }
    var patologic: some View{
        Group{
            Text("4. Pathological Personal Background")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.biomedPrimary)
            VStack{
                TextField("High-Risk Illness", text: self.$illness)
                    .textFieldStyle(.roundedBorder)
                TextField("Current Treatment", text: self.$treatment)
                    .textFieldStyle(.roundedBorder)
                TextField("Treatment Dose", text: self.$doseOfMedication)
                    .textFieldStyle(.roundedBorder)
                DatePicker("When did it begin?", selection: self.$disposableDates[1], in: ...Date.now, displayedComponents: .date)
                    .onChange(of: disposableDates[1], perform: { date in
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        self.illnessDate = formatter.string(from: disposableDates[1])
                    })
                    .fontWeight(.bold)
                    .tint(Color.biomedPrimary)
                    .border(0.2, .gray)
            }
            .frame(minWidth: 0)
        }
    }
    func sendObjectToFireStore(){
        isLoading = true
        closeKeyboards()
        Task{
            do{
                // Step 1: Creating a User Firestore Object
                let medicalRecord = MedicalRecord(userUID: userUID, patientName: patientName, birthDate: birthDate, gender: gender, age: age, maritalStatus: maritalStatus, address: address, cellphoneNumber: cellphoneNumber, hasDiabetes: hasDiabetes, hasObesity: hasObesity, hasHeartDisease: hasHeartDisease, hasHypertension: hasHypertension, hasLungDisease: hasLungDisease, hasCancer: hasCancer, drinkingScale: drinkingScale, smokingScale: smokingScale, fitnesScale: fitnesScale, sleepingHours: sleepingHours, workingStudingHours: workingStudingHours, allergies: allergies, illness: illness, illnessDate: illnessDate, treatment: treatment, doseOfMedication: doseOfMedication)
                // Step 2: Saving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("MedicalRecords").document(userUID).setData(from: medicalRecord, completion: { error in
                    if error == nil{
                        // MARK: Print Saved Succesfully
                        print("Saved Succesfully")
                        isLoading = false
                        logStatus.toggle()
                    }
                })
            }catch{
                // MARK: Deleting Created Account In Case of Failure
                try await Auth.auth().currentUser?.delete()
                await setError(error)
            }
        }
    }
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error)async{
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }


}

struct MedicalRecord_Previews: PreviewProvider {
    static var previews: some View {
        MedicalRecordView()
    }
}
