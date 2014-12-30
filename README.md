GMCoreDataMultipleSectionsTableVC
=================================


UITableViewControllers are most of the time backed with only one NSFetchedResultsController. 

This subclass allows you to easily handle **multiple NSFetchedResultsControllers**, each under a section with a custom title. 

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/637225/5578133/7d826e36-9008-11e4-8d47-be8c394fbbbe.png" alt="Drawing" align="center" width="380"/>
</p>


How To Use It
--


````swift
class YourTableViewController: CoreDataMultipleSourcesTableVC {
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet{
            self.sectionTitles = [<# YOUR SECTION TITLES #>]
            self.fetchedResultsControllers = [<# YOUR FETCHED RESULTS CONTROLLERS #>]
        }
    }
    
    func setupFetch() {
      self.managedObjectContext = <# YOUR MANAGED OBJECT CONTEXT #>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetch()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch(indexPath.section){
        case 0:
            cell = createCellExampleOne(tableView, forOriginalIndexPath: indexPath)
        case 1:
            cell = createCellExampleTwo(tableView, forOriginalIndexPath: indexPath)
        default:
            break
        }
        
        if cell == nil {
            cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            }
        }
        
        return cell!
    }
    
    func createCellExampleOne(tableView: UITableView, forOriginalIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let indexPathComputed = NSIndexPath(forRow: indexPath.row, inSection: 0)
        
        if let c = self.tableView.dequeueReusableCellWithIdentifier("cellExampleOne") as UITableViewCell? {
            cell = c as UITableViewCell
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellExampleOne")
        }
        
        let managedObject = self.fetchedResultsControllers[indexPath.section].objectAtIndexPath(indexPathComputed) as NSManagedObject
        
        cell.textLabel?.text = managedObject.title
        
        return cell
    }
    
    func createCellExampleTwo(tableView: UITableView, forOriginalIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let indexPathComputed = NSIndexPath(forRow: indexPath.row, inSection: 0)
        
        if let c = self.tableView.dequeueReusableCellWithIdentifier("cellExampleTwo") as UITableViewCell? {
            cell = c as UITableViewCell
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellExampleTwo")
        }
        
        let managedObject = self.fetchedResultsControllers[indexPath.section].objectAtIndexPath(indexPathComputed) as NSManagedObject
        
        cell.textLabel?.text = managedObject.title
        
        return cell
    }    

}
````

Future
--

- Allow Mix of NSFetchedResultController & Custom Static/Dynamic Arrays

Help?
--
[@_imton](http://twitter.com/_imton) | [gaston@black.uy](mailto:gaston@black.uy) 

Keywords
- Multiple NSFechedResultsController in UITableViewController
- Mix Static and Dynamic content on UITableViewController
- Two NSFechedResultsController in UITableViewController
