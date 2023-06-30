//
//  GamersCoreDataDAO.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 02.10.2021.
//

import Foundation
import CoreData

class GamersCoreDataDAO: NSObject {
    
    public weak var delegate: GamersDAODelegate?
    
    override init() {
        super.init()
    }
    
    private func mapGamer(_ gamer: Gamer) -> GamersPerson? {
        guard let name: String = gamer.name else {
            return nil
        }
        let person: GamersPerson = GamersPerson(name: name, birthday: gamer.birthday)
        if let set: NSSet = gamer.scores, set.count > 0 {
            for obj: Any in set {
                if let score: Score = obj as? Score, let scoreDate: Date = score.date {
                    person.addScoreWith(date: scoreDate, level: score.level, points: score.points)
                }
            }
        }
        person.scores.sort { (score1: GamersScore, score2: GamersScore) in
            return score1.level < score2.level
        }
        return person
    }
    private func mapGamers(_ gamers: [Gamer]) -> [GamersPerson] {
        let persons: [GamersPerson] = gamers.compactMap({ (gamer: Gamer) in
                return self.mapGamer(gamer)
            })
       return persons
    }
   
}

extension GamersCoreDataDAO: GamersDAO {
    
    func addDelegate(delegate: GamersDAODelegate) {
        self.delegate = delegate
    }
    
    func removeDelegate() {
        self.delegate = nil
    }
    
    func insertNewGamer(name: String, birth: Date?)  {
        CoreDataGamerBase.sharedInstance().context.perform {
            let firstExpr = NSExpression(forKeyPath: "name")
            let secondExpr = NSExpression(forConstantValue: name)
            let predicate: NSComparisonPredicate = NSComparisonPredicate(leftExpression: firstExpr, rightExpression: secondExpr, modifier: NSComparisonPredicate.Modifier.direct, type: NSComparisonPredicate.Operator.equalTo, options: NSComparisonPredicate.Options.caseInsensitive)
            let request = NSFetchRequest<Gamer>(entityName: "Gamer")
            request.predicate = predicate
            guard let number = try? CoreDataGamerBase.sharedInstance().context.count(for: request), number == 0 else {
                
                return
            }
            let newGamer: Gamer = Gamer(context: CoreDataGamerBase.sharedInstance().context)
            newGamer.name = name
            newGamer.birthday = birth
            let score: Score = Score(context: CoreDataGamerBase.sharedInstance().context)
            score.level = 1
            score.points = 0
            score.date = Date()
            newGamer.addToScores(score)
            do {
                try CoreDataGamerBase.sharedInstance().context.save()
                self.delegate?.savingGamers(error: nil)
            } catch {
                CoreDataGamerBase.sharedInstance().context.rollback()
                print("Failed to saving test data: \(error)")
                self.delegate?.savingGamers(error: error)
            }
        }
    }
    
    func insertNewScore(name: String, level: Int16, points: Int32, date: Date) {
        CoreDataGamerBase.sharedInstance().context.perform {
            let firstExpr = NSExpression(forKeyPath: "name")
            let secondExpr = NSExpression(forConstantValue: name)
            let predicate: NSComparisonPredicate = NSComparisonPredicate(leftExpression: firstExpr, rightExpression: secondExpr, modifier: NSComparisonPredicate.Modifier.direct, type: NSComparisonPredicate.Operator.equalTo, options: NSComparisonPredicate.Options.caseInsensitive)
            let request = NSFetchRequest<Gamer>(entityName: "Gamer")
            request.predicate = predicate
            do {
               let result: [Gamer] = try CoreDataGamerBase.sharedInstance().context.fetch(request)
                if let gamer: Gamer = result.first {
                    if let set: NSSet = gamer.scores, set.count > 0 {
                        for obj: Any in set {
                            if let score: Score = obj as? Score {
                                CoreDataGamerBase.sharedInstance().context.delete(score)
                            }
                        }
                    }
                    let score: Score = Score(context: CoreDataGamerBase.sharedInstance().context)
                    score.level = level
                    score.points = points
                    score.date = date
                    gamer.addToScores(score)
                    try CoreDataGamerBase.sharedInstance().context.save()
                    self.delegate?.savingGamers(error: nil)
                }
                
            } catch {
                print("Failed to save score: \(error)")
                self.delegate?.savingGamers(error: error)
            }
        }
    }
    
    func getGamers() {
        CoreDataGamerBase.sharedInstance().context.perform {
            let request = NSFetchRequest<Gamer>(entityName: "Gamer")
            do {
               let result: [Gamer] = try CoreDataGamerBase.sharedInstance().context.fetch(request)
                let persons: [GamersPerson] = self.mapGamers(result)
                self.delegate?.getGamers(gamers: persons, error: nil)
            } catch {
                print("Failed to get gamers list: \(error)")
                self.delegate?.getGamers(gamers: [GamersPerson](), error: error)
            }
        }
    }
    
    func getGamer(name: String) {
        CoreDataGamerBase.sharedInstance().context.perform {
            let firstExpr = NSExpression(forKeyPath: "name")
            let secondExpr = NSExpression(forConstantValue: name)
            let predicate: NSComparisonPredicate = NSComparisonPredicate(leftExpression: firstExpr, rightExpression: secondExpr, modifier: NSComparisonPredicate.Modifier.direct, type: NSComparisonPredicate.Operator.equalTo, options: NSComparisonPredicate.Options.caseInsensitive)
            let request = NSFetchRequest<Gamer>(entityName: "Gamer")
            request.predicate = predicate
            do {
               let result: [Gamer] = try CoreDataGamerBase.sharedInstance().context.fetch(request)
                let persons: [GamersPerson] = self.mapGamers(result)
                self.delegate?.getGamers(gamers: persons, error: nil)
            } catch {
                print("Failed to get gamers list: \(error)")
                self.delegate?.getGamers(gamers: [GamersPerson](), error: error)
            }
        }
    }
    
    func clearDatabase() {
        CoreDataGamerBase.sharedInstance().context.perform {
            let request = NSFetchRequest<Gamer>(entityName: "Gamer")
            do {
               let result: [Gamer] = try CoreDataGamerBase.sharedInstance().context.fetch(request)
                for obj: Gamer in result {
                    CoreDataGamerBase.sharedInstance().context.delete(obj)
                }
                try CoreDataGamerBase.sharedInstance().context.save()
                self.delegate?.deleteAllGamers(error: nil)
            } catch {
                print("Failed to get gamers list: \(error)")
                self.delegate?.deleteAllGamers(error: error)
            }
        }
    }
}
