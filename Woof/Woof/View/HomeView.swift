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
                      //  .foregroundColor(.Teal.opacity(0.8))
                    
                    Spacer()
                    NavigationLink(destination: LocalEventsMapView()) {
                        FunButton(title: "Test Map Events", icon: "person.circle.fill", buttonColor: Color.teal)
                    }.buttonStyle(ExploreButtonStyle())
                    
                   // NavigationLink(destination: ProfileView()) {
                    //    FunButton(title: "Profile", icon: "person.circle.fill", buttonColor: Color.teal)
                   // }
                    //.buttonStyle(ExploreButtonStyle())
                    
                    NavigationLink(destination: SearchView()) {
                        FunButton(title: "Search Businesses", icon: "magnifyingglass", buttonColor: Color.teal)
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
                    NavigationLink(destination: LocalEventsView()) {
                        FunButton(title: "Local Events", icon: "location.fill", buttonColor: Color.teal)
                    }
                    .buttonStyle(ExploreButtonStyle())
                    
//                    NavigationLink(destination: RegisterBusinessView()) {
//                        FunButton(title: "Register Businesses", icon: "magnifyingglass", buttonColor: Color.teal)
//                    }
//                    .buttonStyle(ExploreButtonStyle())
//                    NavigationLink(destination: CreateEventView()) {
//                        FunButton(title: "Create Event", icon: "magnifyingglass", buttonColor: Color.teal)
//                    }
//                    .buttonStyle(ExploreButtonStyle())
//                    
//                    NavigationLink(destination: UpdateEventsListView()) {
//                        FunButton(title: "Update Events", icon: "magnifyingglass", buttonColor: Color.teal)
//                    }
//                    .buttonStyle(ExploreButtonStyle())
//                    
//                    NavigationLink(destination: UpdateBusinessView()) {
//                        FunButton(title: "Update Businesses", icon: "magnifyingglass", buttonColor: Color.teal)
//                    }
//                    .buttonStyle(ExploreButtonStyle())
                    
//                    NavigationLink(destination: LocalEventsMapView()) {
//                                           FunButton(title: "Local events map", icon: "magnifyingglass", buttonColor: Color.teal)
//                                       }
//                                       .buttonStyle(ExploreButtonStyle())
                    
                    
                    if sessionManager.currentUser?.accountType == "business" && !sessionManager.isBusinessOwner {
                        NavigationLink(destination: RegisterBusinessView()) {
                            FunButton(title: "Register Businesses", icon: "magnifyingglass", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                    }else if sessionManager.isBusinessOwner{
                        NavigationLink(destination: CreateEventView()) {
                            FunButton(title: "Create Event", icon: "magnifyingglass", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                        
                        NavigationLink(destination: UpdateEventsListView()) {
                            FunButton(title: "Update Events", icon: "magnifyingglass", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                        
                        NavigationLink(destination: UpdateBusinessView()) {
                            FunButton(title: "Update Businesses", icon: "magnifyingglass", buttonColor: Color.teal)
                        }
                        .buttonStyle(ExploreButtonStyle())
                    }
                    
                    Spacer()
                }
                .padding()
                .overlay(
                    NavigationLink(destination: ProfileView()){
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.orange.opacity(0.8))
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
