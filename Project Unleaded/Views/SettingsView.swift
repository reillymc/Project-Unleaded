//
//  SwiftUIView.swift
//  Project Unleaded
//
//  Created by Reilly Mackenzie-Cree on 25/10/20.
//

import SwiftUI

struct PrefItem: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var enabled: Bool
    var priority: Int
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.editMode) var editMode
    
    
    @State var selectedStates: Set<PrefItem>?
    
    @State var disabledStateList: [PrefItem] = []
    
    @State var stateList: [PrefItem] = (UserDefaults.standard.array(forKey: "enabledData") ?? [PrefItem(id: "QLD", name: "QLD", enabled: true, priority: 0), PrefItem(id: "NSW", name: "NSW", enabled: true, priority: 0), PrefItem(id: "VIC", name: "VIC", enabled: true, priority: 0), PrefItem(id: "WA", name: "WA", enabled: true, priority: 0)]) as! [PrefItem]
    
    
    
    @State var selectKeeperFuels:Set<String>  = Set(UserDefaults.standard.stringArray(forKey: "enabledFuels") ?? [])
    @State var Regions = []
    @State var Fuels = ["U91", "U95", "U98", "E10", "Diesel", "LPG"]
    
    var body: some View {
        NavigationView {
            
            VStack {
                List {
                    Section(header: Text("Enabled").font(.headline).textCase(nil)) {
                        ForEach(stateList.filter{$0.enabled}, id: \.id) { region in
                            Text(region.id).listRowBackground(Color.clear)
                            
                        }
                        .onMove(perform: moveState)
                        .onDelete(perform: removeState)
                        
                    }
                    Section(header: Text("Disabled").font(.headline).textCase(nil)) {
                        ForEach(disabledStateList, id: \.id) { region in
                            HStack{
                                Button(action: {
                                    addState(id: region.id)
                                } ) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .padding(6)
                                        .frame(width: 20, height: 20)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                       
                                }.buttonStyle(PlainButtonStyle())
                                Text(region.id).listRowBackground(Color.clear)
                            }.padding(0)
                            
                            
                        }
                        .onMove(perform: moveState)
                        
                        
                        
                    }
                }.listStyle(InsetGroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
            .environment(\.editMode, .constant(.active))
        }
    }
    
    
    func moveState(from source: IndexSet, to destination: Int) {
        stateList.move(fromOffsets: source, toOffset: destination)
    }
    
    func removeState(at offsets: IndexSet) {
        for offset in offsets {
            disabledStateList.append(stateList[offset])
        }
        stateList.remove(atOffsets: offsets)
    }
    
    func addState(id: String) {
        stateList.append(disabledStateList.first(where: {$0.id == id})!)
        disabledStateList.removeAll(where: {$0.id == id})
        print("Adding")
    }
    
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
