import UIKit

class ViewController: UIViewController {
    
    var game: GameModel!        // Модель игры
    var buttons: [[UIButton]] = []  // Кнопки для игрового поля
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Инициализация игры с размером 10x10
        game = GameModel(rows: 10, columns: 10)
        
        let buttonSize: CGFloat = 30
        let padding: CGFloat = 5
        
        // Создание кнопок для игрового поля
        for row in 0..<game.grid.count {
            var rowButtons: [UIButton] = []
            for col in 0..<game.grid[0].count {
                let button = UIButton(frame: CGRect(x: CGFloat(col) * (buttonSize + padding), y: CGFloat(row) * (buttonSize + padding), width: buttonSize, height: buttonSize))
                button.layer.borderWidth = 1
                button.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
                button.tag = row * game.grid[0].count + col
                self.view.addSubview(button)
                rowButtons.append(button)
            }
            buttons.append(rowButtons)
        }
    }
    
    // Метод для обработки нажатия на клетку
    @objc func cellTapped(_ sender: UIButton) {
        let row = sender.tag / game.grid[0].count
        let col = sender.tag % game.grid[0].count
        game.revealCell(row: row, column: col)
        updateView()  // Обновление состояния интерфейса
    }
    
    // Метод для обновления интерфейса после каждого действия
    func updateView() {
        for row in 0..<game.grid.count {
            for col in 0..<game.grid[0].count {
                let button = buttons[row][col]
                if game.revealed[row][col] {
                    if game.grid[row][col] == -1 {
                        button.setTitle("💣", for: .normal)  // Если мина
                    } else {
                        button.setTitle("\(game.grid[row][col])", for: .normal)  // Показываем число
                    }
                } else {
                    button.setTitle("", for: .normal)  // Если клетка не раскрыта
                }
            }
        }
        
        if game.gameOver {
            let alert = UIAlertController(title: "Game Over", message: "You hit a mine!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
