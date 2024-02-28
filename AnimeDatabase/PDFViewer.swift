//
//  PDFViewer.swift
//  AnimeDatabase
//
//  Created by ShimitsuKoi on 2024/2/28.
//

import SwiftUI
import PDFKit

struct PDFViewer: View {
    var pdfURL: URL
    
    var body: some View {
        NavigationView {
            
            PDFViewWrapper(pdfURL: pdfURL)
                .edgesIgnoringSafeArea(.all)
        }.navigationBarHidden(false) // 显示导航栏
            .navigationBarBackButtonHidden(false) // 显示返回按钮
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .clear // 设置导航栏背景为透明
                nc.navigationBar.setBackgroundImage(UIImage(), for: .default) // 设置导航栏背景图片为透明
                nc.navigationBar.shadowImage = UIImage() // 隐藏导航栏底部分隔线
            })
    }
}

struct PDFViewWrapper: UIViewRepresentable {
    var pdfURL: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        self.setThumbnailView(pdfView)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        if let document = PDFDocument(url: pdfURL) {
            uiView.document = document
        }
    }
    
    func setThumbnailView(_ pdfView:PDFView) {
            let thumbnailView = PDFThumbnailView()
            thumbnailView.translatesAutoresizingMaskIntoConstraints = false
            pdfView.addSubview(thumbnailView)
            
            thumbnailView.leadingAnchor.constraint(equalTo: pdfView.safeAreaLayoutGuide.leadingAnchor).isActive = true
            thumbnailView.trailingAnchor.constraint(equalTo: pdfView.safeAreaLayoutGuide.trailingAnchor).isActive = true
            thumbnailView.bottomAnchor.constraint(equalTo: pdfView.safeAreaLayoutGuide.bottomAnchor).isActive = true

            
            thumbnailView.heightAnchor.constraint(equalToConstant: 40).isActive = true

            thumbnailView.thumbnailSize = CGSize(width: 20, height: 30)
            thumbnailView.backgroundColor = .clear
            thumbnailView.layoutMode = .horizontal
            thumbnailView.pdfView = pdfView
        }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
