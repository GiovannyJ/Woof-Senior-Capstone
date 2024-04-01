//
//  updateEvent.swift
//  Woof
//
//  Created by Bo Nappie on 3/4/24.
//
import SwiftUI


struct UpdateEventView: View {
    @ObservedObject var viewModel: UpdateEventViewModel
    @State private var eventDate: Date // State variable to hold the selected date
    @Environment(\.presentationMode) private var presentationMode
    
    init(event: Event) {
        self.viewModel = UpdateEventViewModel(event: event)
        // Initialize the eventDate with the date from the event
        self._eventDate = State(initialValue: event.eventDate.dateFromISO8601 ?? Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Update Your Pet-Friendly Event")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding()
                
            // input event details
            Form {
                Section(header: Text("Event Information")){
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Event Name")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Event Name", text: $viewModel.event.eventName)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Event Description")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Event Description", text: $viewModel.event.eventDescription)
                    }
                    
                    // DatePicker with custom binding to convert between String and Date
                    DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                        .onChange(of: eventDate, perform: { value in
                            viewModel.event.eventDate = value.iso8601
                        })
                    
//                    TextField("Location", text: $viewModel.event.location)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Event Location")
                            .font(.caption)
                            .foregroundColor(.gray)
                        AddressAutocompleteTextField(text: $viewModel.event.location)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Contact Information")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Contact Information", text: $viewModel.event.contactInfo)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Leash Policy")
//                            .font(.caption)
//                            .foregroundColor(.gray)
                        Toggle("Leash Policy", isOn: $viewModel.event.leashPolicy)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Leash Policy")
//                            .font(.caption)
//                            .foregroundColor(.gray)
                        Toggle("Disabled Friendly", isOn: $viewModel.event.disabledFriendly)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Leash Policy")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Picker("Pet Size Preference", selection: $viewModel.event.petSizePref) {
                            Text("Small Pets").tag("small")
                            Text("Medium Pets").tag("medium")
                            Text("Large Pets").tag("large")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                   
                    
                    if let imageData = viewModel.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    }
                    
                    Button(action: {
                        viewModel.selectEventPicture()
                    }) {
                        HStack {
                            Text("Change Event Picture")
                            if let newProfileImage = viewModel.newEventImage {
                                Image(uiImage: newProfileImage)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        .background(Color.teal.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .sheet(isPresented: $viewModel.isShowingImagePicker) {
                        ImagePicker(image: $viewModel.newEventImage, isPresented: $viewModel.isShowingImagePicker, didSelectImage: viewModel.imagePickerDidSelectImage)
                    }
                }
                
                
                
                Button(action: viewModel.deleteEvent) {
                    Text("Delete Event")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                    .frame(maxWidth: .infinity)
                
                // Submit the event update
                Section {
                    Button(action: {
                        viewModel.updateEvent()
                    }) {
                        Text("Update Event")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(8)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Update Event")
        .background(Color.orange.opacity(0.2))
        .onAppear(){
            viewModel.fetchEventImage()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                if viewModel.alertTitle == "Event Deleted"{
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct UpdateEventView_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event(eventID: 1, attendance_count: 100, businessID: 1, contactInfo: "Contact Information", dataLocation: "Data Location", disabledFriendly: true, eventDate: "2024-01-09 00:00:00", eventDescription: "Event Description", eventName: "Event Name", imgID: nil, leashPolicy: true, location: "Event Location", petSizePref: "Large pets", geolocation: "Event Geolocation")
        
        return UpdateEventView(event: event)
    }
}

extension String {
    var dateFromISO8601: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    var iso8601: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}

