import Foundation

class GameModel {
    var grid: [[Int]]       // Игровая сетка (0 - пусто, -1 - мина)
    var revealed: [[Bool]]  // Массив, показывающий раскрыты ли клетки
    var gameOver = false    // Флаг завершения игры
    
    // Конструктор
    init(rows: Int, columns: Int) {
        grid = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        revealed = Array(repeating: Array(repeating: false, count: columns), count: rows)
        placeMines()        // Размещение мин
        calculateNumbers()   // Расчет чисел вокруг мин
    }
    
    // Метод для случайного размещения мин
    func placeMines() {
        let mineCount = 10 // Количество мин
        var placedMines = 0
        
        while placedMines < mineCount {
            let row = Int.random(in: 0..<grid.count)
            let column = Int.random(in: 0..<grid[0].count)
            
            if grid[row][column] != -1 {  // Если в клетке нет мины
                grid[row][column] = -1    // Размещаем мину
                placedMines += 1
            }
        }
    }
    
    // Метод для вычисления чисел для клеток (сколько мин вокруг)
    func calculateNumbers() {
        for row in 0..<grid.count {
            for col in 0..<grid[0].count {
                if grid[row][col] == -1 { continue }
                
                var mineCount = 0
                for i in -1...1 {
                    for j in -1...1 {
                        let newRow = row + i
                        let newCol = col + j
                        if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[0].count {
                            if grid[newRow][newCol] == -1 {
                                mineCount += 1
                            }
                        }
                    }
                }
                grid[row][col] = mineCount
            }
        }
    }
    
    // Метод для раскрытия клетки
    func revealCell(row: Int, column: Int) {
        if gameOver || revealed[row][column] {
            return
        }
        
        revealed[row][column] = true
        
        if grid[row][column] == -1 {
            gameOver = true
        } else if grid[row][column] == 0 {
            // Раскрытие соседних клеток, если рядом нет мин
            for i in -1...1 {
                for j in -1...1 {
                    let newRow = row + i
                    let newCol = column + j
                    if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[0].count {
                        if !revealed[newRow][newCol] {
                            revealCell(row: newRow, column: newCol)
                        }
                    }
                }
            }
        }
    }
}
