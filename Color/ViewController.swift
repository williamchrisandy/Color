//
//  ViewController.swift
//  Color
//
//  Created by William Chrisandy on 12/05/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableViewColor: UITableView!
    
    var arrayColor: [UIColor] = []
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        applicationWillEnterForeground()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
    }

    @objc func applicationWillEnterForeground()
    {
        let standardUserDefault = UserDefaults.standard
        
        let backgroundColorCode = standardUserDefault.integer(forKey: "homeBackgroundColor")
        let backgroundColor: UIColor = backgroundColorCode == 1 ? .red : (backgroundColorCode == 2 ? .darkGray : .white)
        view.backgroundColor = backgroundColor.withAlphaComponent(standardUserDefault.double(forKey: "homeBackgroundAlpha"))
        
        arrayColor.removeAll()
        if standardUserDefault.bool(forKey: keyShowRed) == true
        {
            arrayColor.append(.red)
        }
        
        if standardUserDefault.bool(forKey: keyShowGreen) == true
        {
            arrayColor.append(.green)
        }
        
        if standardUserDefault.bool(forKey: keyShowBlue) == true
        {
            arrayColor.append(.blue)
        }
        tableViewColor.reloadData()
    }
    
    @objc func longPressHandler(longPressGestureRecognizer: UILongPressGestureRecognizer)
    {
        if longPressGestureRecognizer.state == .began
        {
            let touchPoint = longPressGestureRecognizer.location(in: tableViewColor)
            if let indexPath = tableViewColor.indexPathForRow(at: touchPoint)
            {
                selectedIndexPath = indexPath
                performSegue(withIdentifier: "goToColorDetailSegue", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayColor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellColor")!
        cell.textLabel?.text = arrayColor[indexPath.row].accessibilityName.capitalized
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGestureRecognizer.minimumPressDuration = 3
        
        cell.addGestureRecognizer(longPressGestureRecognizer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToColorDetailSegue"
        {
            let destination = segue.destination as! DetailViewController
            destination.color = arrayColor[selectedIndexPath.row]
        }
    }
}

