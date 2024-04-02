import SwiftUI

struct HomeView: View {
    @ObservedObject private var sessionManager = SessionManager.shared
    @ObservedObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    Text("Welcome Back \(sessionManager.currentUser?.username ?? "Guest")!")
                        .font(.title2)
                        .fontWeight(.bold)
                       // .padding(.leading)
                        .foregroundColor(.orange.opacity(0.8))
                    
                    Text("Discover Pet-Friendly Businesses and Events.")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                    
                  //  Text("Explore")
                   //     .font(.title2)
                    //    .fontWeight(.semibold)
                     //   .padding(.leading)
                      //  .foregroundColor(.teal.opacity(0.8))
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()) {
                        FunButton(title: "Profile", icon: "person.circle.fill", buttonColor: "teal")
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
                    NavigationLink(destination: SearchView()) {
                        FunButton(title: "Search Businesses", icon: "magnifyingglass", buttonColor: "teal")
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
                    NavigationLink(destination: LocalEventsView()) {
                        FunButton(title: "Local Events", icon: "location.fill", buttonColor: "teal")
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
                    
                    if sessionManager.currentUser?.accountType == "business" && !sessionManager.isBusinessOwner {
                        NavigationLink(destination: RegisterBusinessView()) {
                            FunButton(title: "Register Businesses", icon: "magnifyingglass", buttonColor: "teal")
                        }
                        .buttonStyle(ExploreButtonStyle())
                    }else if sessionManager.isBusinessOwner{
                        NavigationLink(destination: CreateEventView()) {
                            FunButton(title: "Create Event", icon: "magnifyingglass", buttonColor: "teal")
                        }
                        .buttonStyle(ExploreButtonStyle())
                        
                        NavigationLink(destination: UpdateEventsListView()) {
                            FunButton(title: "Update Events", icon: "magnifyingglass", buttonColor: "teal")
                        }
                        .buttonStyle(ExploreButtonStyle())
                        
                        NavigationLink(destination: UpdateBusinessView()) {
                            FunButton(title: "Update Businesses", icon: "magnifyingglass", buttonColor: "teal")
                        }
                        .buttonStyle(ExploreButtonStyle())
                    }
                    
                    Spacer()
                }
                .padding()
                .overlay(
                    NavigationLink(destination: UpdateAccountView()){
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red.opacity(0.8))
                            .clipShape(Circle())
                            .padding([.top, .trailing], 16)
                    },
                    alignment: .topTrailing
                )
            }
            .navigationTitle("Home")
            .fontWeight(.light)
        }
    }
}

struct FunButton: View {
    var title: String
    var icon: String
    var buttonColor: String
    
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
                .fill(Color(buttonColor))
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
