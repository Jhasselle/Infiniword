
import UIKit
import WebKit

extension UIView {
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
    

class ViewController: UIViewController, WKUIDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet var SuperUltimateGrandMasterView: UIView!
    @IBOutlet var UIViewCrosswordParent: UIView!
    @IBOutlet var UIViewCrossword: UIView!
    @IBOutlet var UIViewToolBar: UIView!
    @IBOutlet weak var viewForEmbeddingWebView: UIView!
    @IBOutlet var UIViewKeyboard: UIView!
    
    var webView: WKWebView!
    @IBOutlet var KeyboardStackview: UIStackView!
    @IBOutlet var MasterStackview: UIStackView!
    var crossword : Crossword!
    var currentTile = Tile()
    var currentWord = WordStruct()
    var currentWordIndex = 0
    let dictionaryOverlord = DictionaryOverlord()
    
    @IBOutlet var UIViewClue: UIView!
    @IBOutlet var LabelClue: UILabel!
    @IBOutlet var LabelWord: UILabel!
    @IBOutlet var LabelWordNumber: UILabel!
    //    var boardView : UIView!
    @IBOutlet weak var textField: UITextField!
//    var viewHeight : Int!

    // MARK:
    // MARK: ViewController Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.view.intrinsicContentSize)
//        viewHeight = Int(self.view.frame.size.height)
//        // MARK:
//        // MARK: Gesture Stuff
//
//        textField.delegate = self
//
//        //Create gestures
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(getter: self.pinchGesture))
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        self.view.addGestureRecognizer(tapGesture)
//
//        //Create view for where crossword tiles will appear
//        self.boardView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 250))
//        self.boardView.backgroundColor = .purple
//        self.view.addSubview(boardView)
//        self.boardView.addGestureRecognizer(pinchGesture)
        
        initializeCustomViews()
        initializeWebView()
        currentTile = crossword.Tiles[crossword.Words[0].pos.x]
        highlightCurrentTile()
        tilePressed2()
    }
    
    //Defining pinchGesture to mimic zooming in/out
//    @objc func pinchGesture(sender: UIPinchGestureRecognizer){  //allows you to zoom in and out
//        boardView.transform = (boardView.transform.scaledBy(x: sender.scale, y: sender.scale))
//        sender.scale = 1
//    }
//
//    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
//        textField.resignFirstResponder()
//        self.view.frame.origin.y = 0
//    }
    // MARK:
    // MARK: ViewController Stuff
    func viewDidAppear() {
        print("viewDidAppear()")
        initializeMainViews()
        
    }
    
    func initializeCustomViews() {
        
        initializeMasterStackview()
        initializeKeyboardView()
        initializeCrossword()
        initializeKeyboard()
    }
    
    func initializeMainViews() {
        
        let viewHeight = Double(self.view.frame.size.height)
        let viewWidth = Double(self.view.frame.size.width)
        
        print(self.view.bounds)
        
        print(viewHeight)
        print(viewWidth)
        
        let UIViewToolBarY = viewHeight * 0
        let UIViewToolBarHeight = viewHeight * 0.9
        UIViewToolBar.frame = CGRect(x: 0.0, y: UIViewToolBarY, width: viewWidth, height: UIViewToolBarHeight)
        
        let UIViewCrosswordParentY = viewHeight * 0.9
        let UIViewCrosswordParentHeight = viewHeight * 0.66
        UIViewCrosswordParent.frame = CGRect(x: 0.0, y: UIViewCrosswordParentY, width: viewWidth, height: UIViewCrosswordParentHeight)
        
        UIViewCrossword.frame = UIViewCrosswordParent.frame
        //MasterStackview.frame = UIViewCrosswordParent.frame
        
        let UIViewKeyboardY = viewHeight * 0.75
        let UIViewKeyboardHeight = viewHeight * 1.00
        UIViewKeyboard.frame = CGRect(x: 0.0, y: UIViewKeyboardY, width: viewWidth, height: UIViewKeyboardHeight)

//     viewForEmbeddingWebView: UIView!
//
    }

    func initializeMasterStackview() {
        MasterStackview.axis = .vertical
        MasterStackview.alignment = .fill
        MasterStackview.distribution = .fillEqually
        MasterStackview.spacing = CGFloat(3.0)
    }

    func initializeCrossword() {
        crossword = Crossword()
        crossword.initialize(width: 13, height: 150)
        initializeCrosswordRows()
        MasterStackview.addArrangedSubview(crossword)
        crossword.generateCrossword(dict: dictionaryOverlord)

        //DEBUG
        //crossword.DEBUG_GENERATE_CROSSWORD()
    }

    func initializeCrosswordRows() {
        
        var tileIndex = 0
        for y in 0..<crossword.height {
            let newRow = UIStackView()
            newRow.axis = .horizontal
            newRow.alignment = .fill
            newRow.distribution = .fillEqually
            newRow.spacing = CGFloat(5.0)
            
            for x in 0..<crossword.width {
                let newTile = Tile()
                newTile.tileIndex = tileIndex
                tileIndex += 1
                newTile.initialize(xIndex: x, yIndex: y)
                newTile.addTarget(self, action: #selector(tilePressed(_:)), for: .touchUpInside)
                if (y > crossword.displayHeight - 1) {
                    newTile.disable()
                    newTile.hide()
                }
                else {
                    newTile.enable()
                    newTile.show()
                }
                crossword.Tiles.append(newTile)
                newRow.addArrangedSubview(newTile)
                
            }
            crossword.Rows.append(newRow)
            crossword.insertArrangedSubview(newRow, at: 0)
        }
        // Spaghetti:
        //crossword.Rows[13]
        
    }
    // MARK:
    // MARK: Initialize WebView
    func initializeWebView() {
        // let frameSize = CGRect(x: 0, y: 0, width: 400, height: 400)
        let newFrame = viewForEmbeddingWebView.frame
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: newFrame, configuration: webConfiguration)
        webView.uiDelegate = self
        
        viewForEmbeddingWebView.addSubview(webView)
    }
    
    // MARK:
    // MARK: Tile Stuff
    @IBAction func tilePressed(_ sender: Tile) {
        
        unhighlightCurrentTile()
        
        print("TILE PRESSED")
        currentTile = sender
        var wordIndex = 0
        
        if sender.xWordExists {
            wordIndex = sender.xWordIndex
        }
        else if sender.yWordExists {
            wordIndex = sender.yWordIndex
        }
        crossword.highlightWord(wordIndex: wordIndex)
        
        
        currentWord = crossword.Words[wordIndex]
        LabelWord.text = crossword.Words[wordIndex].word // "???"
        LabelClue.text = crossword.Words[wordIndex].clue
        LabelWordNumber.text = String(crossword.Words[wordIndex].wordIndex + 1)
        
        highlightCurrentTile()
    }
    
    func tilePressed2() {
        crossword.highlightWord(wordIndex: 0)
        currentWord = crossword.Words[0]
        LabelWord.text = crossword.Words[0].word // "???"
        LabelClue.text = crossword.Words[0].clue
        LabelWordNumber.text = String(crossword.Words[0].wordIndex + 1)
    }
    
    func unhighlightCurrentTile() {
        self.currentTile.layer.borderWidth = 0
    }
    
    func highlightCurrentTile() {
//        UIView.setAnimationsEnabled(false)
//        UIView.setAnimationsEnabled(true)
        //unhighlightCurrentTile()
        UIView.animate(withDuration: 1.0, delay: 0.0, options:[.autoreverse, .repeat], animations: {
            self.currentTile.layer.borderWidth = 3
            //self.currentTile.layer.borderColor = UIColor.cyan as! CGColor
        }, completion:nil)
    }
    
    func selectTile(wordIndex : Int) {
        
//        currentTile.
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
    }
    // MARK:
    // MARK: Keyboard Stuff
    func initializeKeyboardView() {
        KeyboardStackview.axis = .vertical
        KeyboardStackview.alignment = .fill
        KeyboardStackview.distribution = .fillEqually
        KeyboardStackview.spacing = CGFloat(3.0)
    }

    func initializeKeyboard() {
        let alphabet = "QWERTYUIOPASDFGHJKLZXCVBNM"
        
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.alignment = .fill
        row1.distribution = .equalSpacing
        row1.spacing = CGFloat(5.0)
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.alignment = .fill
        row2.distribution = .equalSpacing
        row2.spacing = CGFloat(5.0)
        
        let row3 = UIStackView()
        row3.axis = .horizontal
        row3.alignment = .fill
        row3.distribution = .equalSpacing
        row3.spacing = CGFloat(5.0)
        
        var currentIndex = 0
        
        for char in alphabet {
            let newKeyboardButton = KeyboardButton()
            let newLetter = String(char)
            newKeyboardButton.letter = newLetter
            newKeyboardButton.setTitle(newLetter, for: .normal)
            newKeyboardButton.backgroundColor = UIColor.blue
            newKeyboardButton.addTarget(self, action: #selector(keyboardPressed(_:)), for: .touchUpInside)
            
            if currentIndex <= 9 {
                row1.addArrangedSubview(newKeyboardButton)
            }
            else if currentIndex <= 18 {
                row2.addArrangedSubview(newKeyboardButton)
            }
            else if currentIndex <= 25 {
                row3.addArrangedSubview(newKeyboardButton)
            }
            currentIndex += 1
        }
        
        // row1, 0 - 9, Q - P
        // row2, 10 - 18, A - L
        // row3, 19 - 25, Z - M
        KeyboardStackview.addArrangedSubview(row1)
        KeyboardStackview.addArrangedSubview(row2)
        KeyboardStackview.addArrangedSubview(row3)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.view.frame.origin.y = -100     //Creates effect of zooming to the text field
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        self.view.frame.origin.y = 0
//        return true
//    }



    
    var iter = 0
    @IBAction func keyboardPressed(_ sender: KeyboardButton) {
        
        let keyboardLetter = sender.titleLabel!.text
        currentTile.setTitle(keyboardLetter, for: .normal)
        unhighlightCurrentTile()
        crossword.highlightWord(wordIndex: iter)
        iter += 1
        if currentTile.xWordExists {
//            print(currentTile.xWordPos)
//            print(currentWord.word)
//            print(currentTile.xIndex)
//            print(currentTile.tileIndex)
            
            
            
//            if currentTile.tileIndex + 1 >
            
            currentTile = crossword.Tiles[currentTile.tileIndex + 1]
            highlightCurrentTile()
        }
        else if currentTile.yWordExists {
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
//    func showWebImages(_ word : String) {
//
//        _ = "https://www.google.com/search?q=cute+cat&tbm=isch&hl=en&tbs=qdr:w"
//
//        let urlStart = "https://www.google.com/search?q="
//        let urlEnd = "&tbm=isch&hl=en&tbs=qdr:w"
//        let searchUrl = urlStart + word + urlEnd
//
//        let myURL = URL(string:searchUrl)
//        let myRequest = URLRequest(url: myURL!)
//
////        webView.load(myRequest)
//
//        print("showWebImages: ", word)
//    }
    
    

    //    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
    //




}

