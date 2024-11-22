//
//  Router.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI

@Observable
class Router {
    
    // All possible routes
    enum Route: Hashable {
        case Home
        case Notes(Friend)
        case EditFriend(Friend)
        case Onboarding
        case Menu
    }
    
    // Used to programatically control navigation stack
    var path: NavigationPath = NavigationPath()
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .Home:
            Home()
        case .EditFriend(let friend):
            EditFriend(friend: friend)
        case .Notes(let friend):
            Notes(friend: friend)
        case .Onboarding:
            Onboarding()
        case .Menu:
            MenuView()
        }
    }
    
    func replace(_ appRoute: Route){
        
        path.append(appRoute)
        path.removeLast(1)
    }
    
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    func navigateBack() {
        if (path.count > 0) {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct RouterView<Content: View>: View {
    
    @Bindable var router: Router = Router()
    // Our root view content
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environment(router)
    }
}
