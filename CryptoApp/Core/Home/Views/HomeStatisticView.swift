//
//  HomeStatisticView.swift
//  CryptoApp
//
//  Created by Nazar Prysiazhnyi on 08.03.2023.
//

import SwiftUI

struct HomeStatisticView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPorfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { StatisticView(stat: $0)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPorfolio ? .trailing : .leading)
    }
}

struct HomeStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticView(showPorfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
