//
//  iPhoneContentView.swift
//  Loan Caculator
//
//  Created by Steve Dao on 7/3/20.
//  Copyright © 2020 Steve Dao. All rights reserved.
//

import SwiftUI

struct PhoneContentView: View {
    
    @ObservedObject var viewModel: LoanCalculatorViewModel
    
    @State private var isShowTable = false
    @State private var isShowHelp = false
    @State private var isShowAmountHints = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        if !viewModel.totalPaidString.isEmpty {
                            LoanSummaryView(viewModel: viewModel).padding(EdgeInsets(top: 8,
                                                                                     leading: 8,
                                                                                     bottom: 16,
                                                                                     trailing: 0))
                        }
                        
                        Text("loan_amount").font(.headline)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            TextField("",
                                      text: $viewModel.amountString,
                                      onEditingChanged: { self.isShowAmountHints = $0 })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .font(.body)
                                    .onChange(of: viewModel.amountString, perform: { newValue in
                                        let valueFormatted = Formatter.currencyFormatter.string(from: NSNumber(value: newValue.toDouble() ?? 0)) ?? ""
                                        if viewModel.amountString != valueFormatted {
                                            viewModel.amountString = valueFormatted
                                        }
                                    })
                            Text(viewModel.amountErrorString).foregroundColor(.red).font(.subheadline)
                            
                            if isShowAmountHints {
                                HStack(alignment: .center, spacing: 8) {
                                    Spacer()
                                    
                                    Button(action: {
                                        self.viewModel.amountString += "000"
                                    }) {
                                        Text(" .000 ")
                                            .fontWeight(.medium)
                                            .font(.subheadline)
                                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                            .background(Color(UIColor.systemGray5)).foregroundColor(Color(UIColor.label))
                                            .cornerRadius(5)
                                    }
                                    
                                    Button(action: {
                                        self.viewModel.amountString += "000000"
                                    }) {
                                        Text(" .000.000 ")
                                            .fontWeight(.medium)
                                            .font(.subheadline)
                                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                            .background(Color(UIColor.systemGray5)).foregroundColor(Color(UIColor.label))
                                            .cornerRadius(5)
                                    }
                                    
                                    Button(action: {
                                        self.viewModel.amountString = ""
                                        
                                    }) {
                                        Text(" clear ")
                                            .fontWeight(.medium)
                                            .font(.subheadline)
                                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                            .background(Color(UIColor.systemGray5)).foregroundColor(Color(UIColor.systemRed))
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        }
                        
                        Text("loan_term").font(.headline)
                        
                        HStack(alignment: .center, spacing: 8) {
                            TextField("", text: $viewModel.termString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .font(.body)
                            
                            Picker("Term by", selection: $viewModel.termType) {
                                Text("years").tag(0).font(.body)
                                Text("months").tag(1).font(.body)
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        
                        Text(viewModel.termErrorString).foregroundColor(.red).font(.subheadline)
                        
                        Text("interest_rate").font(.headline)
                        
                        HStack(alignment: .center, spacing: 8) {
                            VStack(alignment: .center, spacing: 0) {
                                TextField("loan_interest_placeholder", text: $viewModel.interestString)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .font(.body)
                            }.frame(maxWidth: .infinity)
                            
                            VStack(alignment: .center, spacing: 0) {
                                Text("%").font(.body)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text(viewModel.interestErrorString).foregroundColor(.red).font(.subheadline)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .center, spacing: 8) {
                                Text("interest_type").font(.headline)
                                Button(action: {
                                    self.isShowHelp = true
                                }) {
                                    Image(systemName: "info.circle.fill")
                                }
                                .sheet(isPresented: $isShowHelp, onDismiss: {
                                    self.isShowHelp = false
                                }) {
                                    HelpsView()
                                }
                            }
                            
                            Picker("Loan method", selection: $viewModel.loanMethod) {
                                Text("frm").tag(0).font(.body)
                                Text("rbm").tag(1).font(.body)
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        
                    }
                }
                
                // Amortization table button
                if viewModel.isInputsValid {
                    VStack(alignment: .center, spacing: 0, content: {
                        Button(action: {
                            self.isShowTable = true
                        }) {
                            Text("amortization_table").font(.body).fontWeight(.bold)
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color(UIColor.systemBlue))
                        .cornerRadius(4)
                        .sheet(isPresented: $isShowTable, onDismiss: {
                            self.isShowTable = false
                        }) {
                            AmortizationView(amortizations: self.viewModel.amortizations)
                        }
                    })
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            .navigationBarTitle("loan_calculator", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct iPhoneContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneContentView(viewModel: LoanCalculatorViewModel.mockData)
    }
}
