//
//  ConnectionSettingsView.swift
//  MeoAsstMac
//
//  Created by hguandl on 10/10/2022.
//

import SwiftUI

struct ConnectionSettingsView: View {
    @EnvironmentObject private var appDelegate: AppDelegate

    private let gzipInfo = """
    使用 Gzip 压缩有可能会出现内存泄漏，非测试用途建议关闭。
    """

    private let adbLiteInfo = """
    实验性功能，理论性能更好。
    """

    private let playToolsInfo = try! AttributedString(markdown: """
    PlayTools 的使用请参考[文档](https://maa.plus/docs/1.4-Mac%E6%A8%A1%E6%8B%9F%E5%99%A8%E6%94%AF%E6%8C%81.html)。
    """)

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ADB地址")
                TextField("", text: $appDelegate.connectionAddress)
            }

            Toggle(isOn: allowGzip) {
                VStack(alignment: .leading) {
                    Text("允许使用 Gzip")
                    Text(gzipInfo).font(.caption).foregroundColor(.secondary)
                }
            }
            .padding(.top)

            Toggle(isOn: $appDelegate.useAdbLite) {
                VStack(alignment: .leading) {
                    Text("使用 adb-lite 连接")
                    Text(adbLiteInfo).font(.caption).foregroundColor(.secondary)
                }
            }
            .padding(.top)

            Picker("触控模式", selection: $appDelegate.touchMode) {
                ForEach(MaaTouchMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                }
            }
            .padding(.top)

            if appDelegate.touchMode == .MacPlayTools {
                Text(playToolsInfo).font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }

    private var allowGzip: Binding<Bool> {
        Binding {
            appDelegate.connectionProfile == "Compatible"
        } set: { allow in
            if allow {
                appDelegate.connectionProfile = "Compatible"
            } else {
                appDelegate.connectionProfile = "CompatMac"
            }
        }
    }
}

struct ConnectionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionSettingsView()
            .environmentObject(AppDelegate())
    }
}

enum MaaTouchMode: String, CaseIterable {
    case adb
    case minitouch
    case maatouch
    case MacPlayTools
}
