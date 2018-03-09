/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Cocoa

class ViewController: NSViewController {
  
  dynamic var loading = false
  @IBOutlet weak var numberResultsComboBox: NSComboBox!
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var searchTextField: NSTextField!
  
  override func viewDidLoad() {
    
    
    super.viewDidLoad()
    let itemPrototype = self.storyboard?.instantiateController(withIdentifier:
      "collectionViewItem") as! NSCollectionViewItem
    collectionView.itemPrototype = itemPrototype
  }
    @IBOutlet var searchResultsController: NSArrayController!
    
    @IBAction func searchClicked(_ sender: Any) {
      loading = true;
      if(searchTextField.stringValue == ""){
        return
      }
      guard let resultsNumber = Int(numberResultsComboBox.stringValue) else {
        return
      }
      iTunesRequestManager.getSearchResults(searchTextField.stringValue, results: resultsNumber, langString: "en_us") { (results, error) in
        let itunesResults = results.map {return Result(dictionary:$0)}
        
          .enumerated()
          .map({ index, element -> Result in
            element.rank = index + 1
            return element
          })
        
        DispatchQueue.main.async {
          self.searchResultsController.content = itunesResults
          self.loading = false
          //print(self.searchResultsController.content)
        }
        
      }
    }
  func tableViewSelectionDidChange(_ notification: NSNotification) {
    //2
    guard let result = searchResultsController.selectedObjects.first as? Result else { return }
    //3
    result.loadIcon()
    result.loadScreenShots()
  }
  
}
extension ViewController: NSTextFieldDelegate {
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    if commandSelector == #selector(insertNewline(_:)) {
      searchClicked(searchTextField)
    }
    return false
  }
  
}
