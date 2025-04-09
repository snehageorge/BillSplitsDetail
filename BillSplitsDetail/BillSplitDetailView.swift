//
//  BillSplitDetailView.swift
//  BillSplitsDetail
//
//  Created by Sneha on 07/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct BillSplitDetailView: View {
    @StateObject var viewModel = BillDetailsViewModel()
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .all)
            VStack {
                ScrollView {
                    //TODO: Implement navigation bar
                    if let bill = viewModel.bill {
                        VStack {
                            BillDetailHeaderView(bill: bill)
                            BillDetailSplitView(bill: bill)
                        }
                        .padding()
                    }
                }
                BillDetailSendButton()
                    .padding()
            }
            .frame(maxHeight: .infinity)
        }
        .task {
            await viewModel.fetchBills()
        }
    }
}

struct BillDetailHeaderView: View {
    var bill: Bill
    
    var body: some View {
        ZStack {
            VStack {
                WebImage(url: URL(string: bill.foodImage))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 130)
                
                
                Text("$\(bill.totalAmount, specifier: "%.2f")")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                
                
                HStack {
                    Text(bill.shopName)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .fontWeight(.bold)
                    Circle()
                        .frame(width: 3, height: 3)
                        .foregroundColor(.gray)
                    
                    Text("Total Bill")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .fontWeight(.bold)
                    
                    Circle()
                        .frame(width: 3, height: 3)
                        .foregroundColor(.gray)
                    
                    Text("Details")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct BillDetailSplitView: View {
    var bill: Bill
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            ForEach(Array(bill.friends.enumerated()), id: \.element.friendId) { index, friend in
                
                VStack {
                    Text(friend.name)
                        .foregroundColor(.white)
                        .font(.caption2)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 0) {
                        WebImage(url: URL(string: friend.userImage))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        if friend.isPaid {
                            BillSplitPaidView()
                            Text("Paid")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                                .fontWeight(.bold)
                        } else {
                            BillSplitPendingView(splitAmount: friend.amount, totalAmount: bill.totalAmount)
                            Text("")
                        }
                        
                        
                        Text("$\(friend.amount, specifier: "%.2f")")
                            .foregroundStyle(.white)
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .offset(y: index % 2 == 0 ? 0 : 10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct BillSplitPaidView: View {
    let sliderHeight: CGFloat = 280
    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(Color.yellow)
                .frame(width:1, height: sliderHeight)
            
            Circle()
                .fill(Color.black)
                .stroke(Color.yellow, lineWidth: 2)
                .frame(width: 30, height: 20)
                .overlay {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 10)
                        .foregroundStyle(Color.yellow)
                }
        }
    }
}

struct BillSplitPendingView: View {
    let splitAmount: Double
    let totalAmount: Double
    let sliderHeight: CGFloat = 280
    var body: some View {
        ZStack(alignment: .top) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 1, height: sliderHeight)
            
            Capsule()
                .fill(Color.yellow)
                .frame(width: 1, height: CGFloat(splitAmount / totalAmount) * sliderHeight)
            
            Circle()
                .fill(Color.black)
                .stroke(Color.yellow, lineWidth: 3)
                .frame(width: 15, height: 15)
                .offset(y: CGFloat(splitAmount / totalAmount) * sliderHeight)
        }
    }
}

struct BillDetailSendButton: View {
    @State private var offsetX: CGFloat = 0
    @State private var isSent = false
    
    let buttonWidth: CGFloat = 360
    let circleSize: CGFloat = 50
    
    var body: some View {
        if !isSent {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.yellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                
                HStack {
                    Spacer()
                    Text("Swipe to send")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.yellow)
                    Spacer()
                }
                
                Circle()
                    .fill(Color.black)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    )
                    .padding(.leading, 5)
                    .offset(x: offsetX)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 && offsetX < (buttonWidth - circleSize - 10) {
                                    offsetX = value.translation.width
                                }
                            }
                            .onEnded { _ in
                                if offsetX > buttonWidth * 0.7 {
                                    withAnimation {
                                        offsetX = buttonWidth - circleSize - 10
                                        isSent = true
                                    }
                                } else {
                                    withAnimation {
                                        offsetX = 0
                                    }
                                }
                            }
                    )
            }
            .frame(width: buttonWidth)
        }
        if isSent {
            Text("Bill Sent Successfully! 🎉")
                .font(.caption2)
                .foregroundColor(.green)
                .transition(.fade)
        }
    }
}

#Preview {
    BillSplitDetailView()
}
