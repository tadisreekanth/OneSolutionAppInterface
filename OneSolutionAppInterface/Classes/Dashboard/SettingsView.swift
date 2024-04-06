//
//  SettingsView.swift
//  OneSolutionAppInterface
//
//  Created by Sreekanth Reddy Tadi on 06/10/23.
//

import SwiftUI
import OneSolutionUtility

enum Settings : String {
    case vibrate = "vibrationScan"
    case sound = "soundScan"
    case none = ""
    
    
    var isToggled: Bool {
        (UserDefaults.standard.object(forKey: self.rawValue) as? Bool) ?? false
    }
    
    var text: String {
        switch self {
        case .sound: return "Enable Sound on Scan"
        case .vibrate: return "Vibrate on Scan"
        default: return ""
        }
    }
    
    func save(with status: Bool) {
        UserDefaults.standard.setValue(status, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
}


struct SettingsView: View {
    @Binding var showSelf: Bool
    var arrSettings = [Settings]()
    
    init(_ showSettings: Binding<Bool>) {
        self._showSelf = showSettings
        arrSettings = [.sound, .vibrate]
    }
    
    var body: some View {
        OneSolutionBaseView {
            HeaderView(back: (true, {
                self.showSelf.toggle()
            }), home: (true, {
                self.showSelf.toggle()
            }), title: "Settings")
                        
            VStack(spacing: 8) {
                Spacer().frame(height: 25)
                ForEach(arrSettings, id: \.rawValue) { setting in
                    if #available(iOS 14.0, *) {
                        SettingsTypeView(type: setting)
                            .basicHeight()
                            .background(Color.app_white)
                            .cornerRadius(subViewCornerRadius)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

@available(iOS 14.0, *)
struct SettingsTypeView: View {
    @State private var isToggled = false
    private var type: Settings
    
    init(type: Settings) {
        self.isToggled = type.isToggled
        self.type = type
    }
    
    var body: some View {
        HStack {
            Text(type.text)

            Toggle("", isOn: $isToggled)
                .onChange(of: isToggled) { newValue in
                    self.update()
                }
        }
        .padding(.horizontal, 10)
    }
    
    private func update() {
        self.type.save(with: isToggled)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            Binding.constant(true)
        )
    }
}
