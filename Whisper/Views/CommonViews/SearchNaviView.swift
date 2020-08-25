import SwiftUI

struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var searchText:String
    @Binding var isEditing:Bool
    
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content(),text: self.searchText,isEditing: self.isEditing)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(),searchText: $searchText, searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        let rootViewController: UIHostingController<Content>
        let searchController = NaviSearchController(searchResultsController: nil)
        @Binding var text: String
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>,
             searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            
            //添加搜索控件
            rootViewController = UIHostingController(rootView: content)
            rootViewController.navigationItem.searchController = searchController
            rootViewController.navigationItem.hidesSearchBarWhenScrolling = false
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
            
            super.init()
            
            searchController.searchBar.text = self.text
            searchController.searchBar.placeholder = "搜索歌曲、歌手、专辑"
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            
            //调整光标颜色
            searchController.searchBar.barTintColor = UIColor(named: "ThemeColorMain")
            searchController.searchBar.returnKeyType = .search
        }
        
        func update(content: Content,text:String,isEditing:Bool) {
            //外部取消时 取消
            if(self.searchController.searchBar.text != nil && searchController.searchBar.text != ""
                && !isEditing && text == "")
            {
                DispatchQueue.main.async {
                    self.searchController.searchBar.text = nil
                    if let btn:UIButton = self.searchController.searchBar.value(forKey:"cancelButton") as? UIButton
                    {
                        btn.sendActions(for: .touchUpInside)
                    }
                }
            }
            
            //外部设置搜索条件时 聚焦
            if((self.searchController.searchBar.text == nil || searchController.searchBar.text == "")
                 && text != "")
            {
                searchController.searchBar.text = text
                searchController.searchBar.becomeFirstResponder()
            }
            
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
}

class NaviSearchController:UISearchController {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.menuItems = nil
        UIMenuController.shared.hideMenu()
        return false
    }
    
    override func becomeFirstResponder() -> Bool {
        return false
    }
    
    override func accessibilityElementDidBecomeFocused() {
        super.accessibilityElementDidBecomeFocused()
        print("111")
    }
    
    override func reloadInputViews() {
        super.reloadInputViews()
        print("222")
    }
}
