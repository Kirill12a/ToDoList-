import UIKit
import CoreData


class TableViewController: UITableViewController {
    var array : [Task] = []
    
    //метод для получения context свойства persistentContainer Core Data Stack
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        //добавляем АлертКонтроллер
        let alert = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        
        //создаем Actionы для АлертКонтроллера
       //первый Action
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            // добираемся до текстового полоя АлертКонтроллера
            let tf = alert.textFields?.first
            if let newTask = tf?.text { //если можем получить текст из текстового поля tf - присваеваем переменной newTask(новое задание)
                self.saveTask(withTitle : newTask) //метод для сохранения newTask в CoreData
                self.tableView.reloadData() // перерисовка таблицы для отображения нового элемента
            }
        }
        
        //добавляем поле ввода newTask
        alert.addTextField { _ in }
                
        //второй Action
        let cancelAction = UIAlertAction(title: "Cansel", style: .default) { (_) in }
        
        //добавляем Actions в АлертКонтроллер
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        //отображаем АлертКонтроллер
        present(alert, animated: true, completion: nil)
    }
    
    //реализация метода saveTask(withTitle : _) для сохранения данных в CoreData
    private func saveTask(withTitle title: String){
        //добираемся до viewContext свойства persistentContainer Core Data Stack
        
        let context = getContext()
        
        //добираемся до сущности Task
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
         //получаем task-объект
        let taskObject = Task(entity: entity, insertInto: context)
        
        //помещаем заголовок в task-объект
        taskObject.title = title
        
        //сохраняем context чтоб изменения попали в базу данных
        do {
            try context.save()
            array.append(taskObject)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
    //для отображения данных используем метод viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //получаем context чтоб из этого contexta  можно было получить объекты хранящиеся по сущности Task
        let context = getContext()
        
        //создаем запрос по которому можно получить все объекты хранящиеся в энтити Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        //получаем наши объекты
        do {
            array = try context.fetch(fetchRequest)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       /*
        //удаление всего из CoreData
        let context = getContext()
        //создаем запрос по которому можно получить все объекты хранящиеся в энтити Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let result = try? context.fetch(fetchRequest){
            for object in result{
                context.delete(object)
            }
        }
        //сохраняем context чтоб изменения попали в базу данных
            do {
                try context.save()
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        
        */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

      let task = array[indexPath.row] //записвываем в переменную task значение из массива типа Task
        cell.textLabel?.text = task.title //записвываем в каждую строку таблицы значение из перемнной типа Task и его свойства title

        return cell
    }

}
