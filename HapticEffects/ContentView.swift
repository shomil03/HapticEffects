//
//  ContentView.swift
//  HapticEffects
//
//  Created by Shomil Singh on 13/03/24.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var counter = 0
    @State var engine : CHHapticEngine?
    var body: some View {
        VStack {
            Button("Counter : \(counter)"){
                counter+=1
            }
            .sensoryFeedback(.impact(flexibility: .soft, intensity: 1), trigger: counter)
            
            Button("Engine"){
                ComplexSuccess()
            }
        }
        .onAppear(perform: {
            prepareEngine()
        })
    }
    
    func prepareEngine(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else{return}
        do{
            engine = try CHHapticEngine()
            try engine?.start()
        }catch{
            print("There was an error creating engine \(error.localizedDescription)")
        }
    }
    
    func ComplexSuccess(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else{return}
        
        var events = [CHHapticEvent]()
        
        
        for i in stride(from: 0, to: 2, by: 0.1)
        {
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity , sharpness], relativeTime: i)
            events.append(event)
        }
        for i in stride(from: 0, to: 2, by: 0.1)
        {
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(2-i))
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(2-i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity , sharpness], relativeTime: 2+i)
            events.append(event)
        }
        do{
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
           try player?.start(atTime: 0)
        }catch{
            print("There was an error starting the engine \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
