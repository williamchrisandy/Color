//
//  DetailViewController.swift
//  Color
//
//  Created by William Chrisandy on 13/05/22.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var labelText: UILabel!
    
    var color: UIColor!
    let standardUserDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = color
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        updateText()
        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
    }
    
    @objc func updateText()
    {
        labelText.text = standardUserDefaults.string(forKey: keyText)
    }
    
    @IBAction func editText(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Edit Text", message: "You can also edit this message in the settings", preferredStyle: .alert)
        
        alert.addTextField
        {
            [unowned self] textField in
            textField.placeholder = "Enter Text"
            textField.text = standardUserDefaults.string(forKey: keyText)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            [unowned alert, unowned self] action in
            standardUserDefaults.set(alert.textFields?[0].text, forKey: keyText)
            updateText()
        }

        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
}
