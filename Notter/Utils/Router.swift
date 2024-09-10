//
//  Router.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import SwiftUI

@Observable
class Router {
    // Contains the possible destinations in our Router
    enum Route: Hashable {
        case Home
        case Notes(Friend)
        case EditFriend(Friend)
    }
    
    // Used to programatically control our navigation stack
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
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack() {
        if (path.count > 0) {
            path.removeLast()
        }
    }
    
    // Pop to the root screen in our hierarchy
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
