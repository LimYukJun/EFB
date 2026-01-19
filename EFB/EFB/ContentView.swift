//
//  ContentView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var ctx: FlightContext
    //@StateObject private var ctx = FlightContext()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(ctx: ctx)
        } detail: {
            Text("Select EFB Section")
                .font(.largeTitle)
        }
    }
}
