//
//  main.swift
//  Lesson 5
//
//  Created by Сергей Беляков on 18.03.2021.
//

import Foundation

enum WindowState: String {
    case open = "открыты"
    case closed = "закрыты"
}

enum DoorState: String {
    case open = "открыты"
    case closed = "закрыты"
}

enum EngineState: String {
    case running = "запущен"
    case stopped = "заглушен"
}

protocol CarProtocol: class {
    var year: Int { get }
    var model: String { get }
    var doorState: DoorState { get set }
    var engineState: EngineState { get set }
    var windowState: WindowState { get set }
    
    func doorSwitch(_ state: DoorState)
    func engineSwitch(_ state: EngineState)
    func windowSwitch(_ state: WindowState)
}

extension CarProtocol {

    func doorSwitch(_ state: DoorState) {
        doorState = state
        print("Двери были \(doorState.rawValue)")
    }
    
    func engineSwitch(_ state: EngineState) {
        engineState = state
        print("Двигатель был \(engineState.rawValue)")
    }
    
    func windowSwitch(_ state: WindowState) {
        windowState = state
        print("Окна были \(windowState.rawValue)")
    }
}

class SportCar: CarProtocol {
    
    enum RoofState: String {
        case open = "открыта"
        case closed = "закрыта"
    }
    
    enum SpoilerState: String {
        case raised = "поднят"
        case lowered = "опущен"
    }
    
    var year: Int = 0
    var model: String = ""
    var doorState: DoorState
    var engineState: EngineState
    var windowState: WindowState
    var spoilerState: SpoilerState
    var roofState: RoofState
    
    init (year: Int, model: String, doorState: DoorState, engineState: EngineState, windowState: WindowState, spoilerState: SpoilerState, roofState: RoofState) {
        self.year = year
        self.model = model
        self.doorState = doorState
        self.engineState = engineState
        self.windowState = windowState
        self.spoilerState = spoilerState
        self.roofState = roofState
    }
    
    func spoilerSwitch(_ spoiler: SpoilerState) {
        spoilerState = spoiler
        print("Спойлер был \(spoilerState.rawValue)")
    }
        
    func roofSwitch(_ roof: RoofState) {
        roofState = roof
        print("Откидная крыша была \(roofState.rawValue)")
    }
}

extension SportCar: CustomStringConvertible{
    var description: String {
        return """
            -----------------------------
            Информация:
            Модель: \(self.model)
            Год выпуска: \(self.year)
            Двери: \(self.doorState.rawValue)
            Двигатель: \(self.engineState.rawValue)
            Окна: \(self.windowState.rawValue)
            Спойлер: \(self.spoilerState.rawValue)
            Откидная крыша: \(self.roofState.rawValue)
            ------------------------------
            """
    }
}

var supra = SportCar(year: 2000, model: "Toyota Supra", doorState: .closed, engineState: .stopped, windowState: .closed, spoilerState: .lowered, roofState: .closed)

print(supra)
supra.doorSwitch(.open)
supra.engineSwitch(.running)
supra.windowSwitch(.open)
supra.roofSwitch(.open)

var skyline = SportCar(year: 2009, model: "Nissan Skyline", doorState: .closed, engineState: .stopped, windowState: .closed, spoilerState: .lowered, roofState: .open)

print(skyline)
skyline.doorSwitch(.open)
skyline.roofSwitch(.open)
skyline.engineSwitch(.running)
skyline.spoilerSwitch(.raised)
skyline.engineSwitch(.stopped)
skyline.spoilerSwitch(.lowered)
skyline.doorSwitch(.closed)
// MARK: -

class TrunkCar: CarProtocol {
    
    enum TrailerState: String {
        case installed = "установлен"
        case uninstalled = "снят"
    }
    
    var year: Int = 0
    var model: String = ""
    var doorState: DoorState
    var engineState: EngineState
    var windowState: WindowState
    var trailerState: TrailerState
    let trunkVolume: Double
    let trailerVolume: Double
    var usedTrunkVolume: Double
    var totalTrunkVolume: Double {
        get {
            if trailerState == .installed {
                return trunkVolume + trailerVolume
            } else  {
                return trunkVolume
            }
        }
    }
    
    init (year: Int, model: String, doorState: DoorState, engineState: EngineState, windowState: WindowState, trailerState: TrailerState, trunkVolume: Double, trailerVolume: Double, usedTrunkVolume: Double) {
        self.year = year
        self.model = model
        self.doorState = doorState
        self.engineState = engineState
        self.windowState = windowState
        self.trailerState = trailerState
        self.trunkVolume = trunkVolume
        self.trailerVolume = trailerVolume
        self.usedTrunkVolume = usedTrunkVolume
    }
    
    func trailerSwitch(_ trailer: TrailerState) {
        trailerState = trailer
        print("Прицеп был \(trailerState.rawValue)")
        print("Теперь объем кузова: \(totalTrunkVolume)")
    }
    
    func trunkLoad(_ cargo: Double) {
        print("---------------------------------")
        print("Пытаемся загрузить груз объемом \(cargo)")
        if (usedTrunkVolume + cargo) <= totalTrunkVolume {
            usedTrunkVolume += cargo
            print("Груз загружен.")
            printTrunkLoad()
        } else if (usedTrunkVolume + cargo) > totalTrunkVolume && trailerState == .uninstalled {
            print("Недостаточно места. Свободно только \(totalTrunkVolume - usedTrunkVolume). Выгрузите \(cargo - (totalTrunkVolume - usedTrunkVolume)), или установите прицеп")
            printTrunkLoad()
            
        } else if (usedTrunkVolume + cargo) > totalTrunkVolume && trailerState == .installed {
            print("Недостаточно места. Свободно только \(totalTrunkVolume - usedTrunkVolume). Выгрузите \(cargo - (totalTrunkVolume - usedTrunkVolume))")
            printTrunkLoad()
        }
    }
        
    func trunkUnload(_ cargo: Double) {
        print("---------------------------------")
        print("Выгружаем груз объемом \(cargo)")
        if (usedTrunkVolume - cargo) >= 0 {
            usedTrunkVolume -= cargo
            print("Груз выгружен.")
            printTrunkLoad()
        } else if (usedTrunkVolume - cargo) < 0 {
            print("Вы пытаетесь выгрузить больше груза, чем есть в багажнике. Будет выгружен весь оставшийся груз: \(usedTrunkVolume)")
            usedTrunkVolume = 0
            printTrunkLoad()
        }
    }
        
    func printTrunkLoad() {
        print("Загрузка багажника: \(usedTrunkVolume) из \(totalTrunkVolume)")
        print("Прицеп  сейчас \(trailerState.rawValue)")
        
        if usedTrunkVolume <= trunkVolume && trailerState == .installed {
            print("Если не планируете добавлять груз, прицеп можно отсоединить, так как объема основного кузова достаточно для текущего груза")
        }
    }
}

extension TrunkCar: CustomStringConvertible {
    var description: String {
        """
            -----------------------------
            Информация:
            Модель: \(self.model)
            Год выпуска: \(self.year)
            Двери: \(self.doorState.rawValue)
            Двигатель: \(self.engineState.rawValue)
            Окна: \(self.windowState.rawValue)
            Объем кузова: \(self.trunkVolume)
            Объем прицепа: \(self.trailerVolume)
            Прицеп: \(self.trailerState.rawValue)
            Общий объём: \(self.totalTrunkVolume)
            ------------------------------
            """
    }
}
var kamaz = TrunkCar(year: 1990, model: "Kamaz", doorState: .closed, engineState: .stopped, windowState: .closed, trailerState: .uninstalled, trunkVolume: 1000, trailerVolume: 1500, usedTrunkVolume: 300)

print(kamaz)
kamaz.doorSwitch(.open)
kamaz.engineSwitch(.running)
kamaz.trunkLoad(1500)
kamaz.trailerSwitch(.installed)
kamaz.trunkLoad(1500)
kamaz.trunkUnload(800)
kamaz.trailerSwitch(.uninstalled)
kamaz.engineSwitch(.stopped)
kamaz.doorSwitch(.closed)

var man = TrunkCar(year: 2010, model: "Man", doorState: .open, engineState: .running, windowState: .open, trailerState: .uninstalled, trunkVolume: 2000, trailerVolume: 3000, usedTrunkVolume: 0)

print(man)
man.trunkLoad(3500)
man.trailerSwitch(.installed)
man.trunkLoad(3500)
man.trunkUnload(1500)
man.trailerSwitch(.uninstalled)
