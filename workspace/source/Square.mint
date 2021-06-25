enum SquareType {
  Free
  Necessity
}

component Square {
  connect SquareStore exposing { selectedType, squares, toggleSquare }
  property time : String
  property type : SquareType

  style red {
    background: red;
    width: 100px;
    height: 100px;
  }

  style blue {
    background: blue;
    width: 100px;
    height: 100px;
  }

  fun onClick {
    toggleSquare(time)
  }

  fun render : Html {
    case (type) {
      SquareType::Free => <div::red onClick={onClick}/>
      SquareType::Necessity => <div::blue onClick={onClick}/>
    }
  }
}
