//
//  AppDelegate.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 15/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults()
        let aberto = defaults.bool(forKey: "aberto")
        let dia = defaults.integer(forKey: "dia")
        let ultimoDia = defaults.integer(forKey: "ultimoDia")
        
        if !aberto{
            do {
                if let path = Bundle.main.path(forResource: "capitulos", ofType: "json", inDirectory: nil)
                {
                    let url = URL(fileURLWithPath: path)
                    let jsonData = try Data(contentsOf: url)
                    let aulas = try JSONDecoder().decode(Capitulos.self, from: jsonData)
                    
                    for i in 0...aulas.count-1{
                        let registro = NSEntityDescription.insertNewObject(forEntityName: "Capitulo", into: self.persistentContainer.viewContext) as! Capitulo
                        
                        registro.titulo = aulas[i].titulo
                        registro.lido = false
                        registro.dia = aulas[i].dia
                        
                        self.saveContext()
                    }
                    
                    print("Inserido com sucesso")
                }
            } catch {
                print("Erro ao inserir os dados dos capitulos")
            }
            defaults.set(true, forKey: "aberto")
            defaults.set(1, forKey: "dia")
            defaults.set(Calendario.shared.retornaDiaNumero(), forKey: "ultimoDia")
        }
        
        let options: UNAuthorizationOptions = [.alert,.sound,.badge]
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("Notifications not allowed by user")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DiarioDeOracao")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configuraAcoesNotificacao() -> UNNotificationCategory {
        let adiar = UNNotificationAction(identifier: "ADIAR",
                                         title: "Lembre-me em 5 minutos",
                                         options: UNNotificationActionOptions(rawValue: 0))
        
        let concluir = UNNotificationAction(identifier: "CONCLUIR",
                                            title: "Ver agora",
                                            options: [.foreground])
        
        let categoriaLembrete = UNNotificationCategory(identifier: "DIARIO_NOTIFICACOES",
                                                       actions: [adiar, concluir],
                                                       intentIdentifiers: [],
                                                       options: .customDismissAction)
        
        return categoriaLembrete
    }
    
    func criaConteudo() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hora da sua devocional", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Lembre-se de reservar um tempo para meditar na Bíblia e orar", arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "DIARIO_NOTIFICACOES"
        
        return content
    }
    
    func repeteNotificacao(tempo: Double) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let categoria = self.configuraAcoesNotificacao()
                
                let content = self.criaConteudo()
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempo, repeats: false)
                
                let request = UNNotificationRequest(identifier: "repeticao", content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.setNotificationCategories([categoria])
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }
    
    func enviaNotificacao(data: DateComponents) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let categoria = self.configuraAcoesNotificacao()
                
                let content = self.criaConteudo()
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: data, repeats: true)
                
                let request = UNNotificationRequest(identifier: "lembrete", content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.setNotificationCategories([categoria])
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        if content.categoryIdentifier == "DIARIO_NOTIFICACOES" {
            switch response.actionIdentifier {
            case "ADIAR":
                DispatchQueue.main.async(execute: {
                    self.repeteNotificacao(tempo: 300)
                    })
                break
                
            case "CONCLUIR":
                break
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        switch identifier {
        case "ADIAR":
            notification.fireDate = NSDate().addingTimeInterval(300) as Date
            application.scheduleLocalNotification(notification)
            break
        default:
            break
        }
        completionHandler()
    }
}

