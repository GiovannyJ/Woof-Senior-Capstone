import SwiftUI

struct HomeView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @ObservedObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 25) {
            ScrollView {
                VStack{
                    Spacer() // Pushes the profile button to the top
                    HStack {
                        Spacer() // Pushes the profile button to the right
                        NavigationLink(destination: ProfileView()){
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.orange.opacity(0.8))
                                .clipShape(Circle())
                                .padding([.top, .trailing], 16)
                        }
                    }
                }
                    Spacer(minLength: 40)
                    Text("Welcome Back \(sessionManager.currentUser?.username ?? "Guest")!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange.opacity(0.8))
                    
                    Text("Discover Pet-Friendly Businesses and Events.")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                    
                    
                    NavigationLink(destination: SearchView()) {
                        FunButton(title: "Search Businesses", icon: "magnifyingglass", buttonColor: Color.teal)
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
                    NavigationLink(destination: LocalEventsView()) {
                        FunButton(title: "Local Events", icon: "location.fill", buttonColor: Color.teal)
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
                    
                    if sessionManager.currentUser?.accountType == "business" && !sessionManager.isBusinessOwner {
                        NavigationLink(destination: RegisterBusinessView()) {
                            FunButton(title: "Register Businesses", icon: "plus", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                    } else if sessionManager.isBusinessOwner {
                        NavigationLink(destination: CreateEventView()) {
                            FunButton(title: "Create Event", icon: "plus", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                        
                        NavigationLink(destination: UpdateEventsListView()) {
                            FunButton(title: "Update Events", icon: "pencil.circle", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                        
                        NavigationLink(destination: UpdateBusinessView()) {
                            FunButton(title: "Update Businesses", icon: "pencil.circle", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                    }
                    
                    Spacer()
                }
                
            }
            .padding()
//            .overlay(
//                NavigationLink(destination: ProfileView()){
//                    Image(systemName: "person.crop.circle.fill.badge.plus")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.orange.opacity(0.8))
//                        .clipShape(Circle())
//                        .padding([.top, .trailing], 16)
//                },
//                alignment: .topTrailing
//            )
        }
    }
}


struct FunButton: View {
    var title: String
    var icon: String
    var buttonColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.white)
            
            Text(title)
                .foregroundColor(.primary)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(buttonColor.opacity(0.1))
        )
        .padding(.horizontal, 20)
    }
}

struct ExploreButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Color.teal.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
