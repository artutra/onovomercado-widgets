enum SquareType {
  Sleep
  Eat
  Work
  Necessity
  Free
}

component Square {
  connect SquareStore exposing { selectedType, squares, toggleSquare }
  property time : String
  property type : SquareType

  style container {
    position: relative;
    padding: 10px;
    border-left-width: 2px;
    border-top-width: 2px;
    border-bottom-width: 2px;
    border-right-width: 0px;
    border-style: solid;
    border-color: #e7004c;
  }

  style spacing {
    padding-top: 30px;
    padding-bottom: 20px;
  }

  style time {
    position: absolute;
    padding: 0;
    margin: 0;
    top: -60px;
    left: -20px;
  }

  style line {
    padding-top: 30px;
    border-left: 2px solid #e7004c;
  }

  fun onClick {
    toggleSquare(time)
  }

  fun render : Html {
    <div::spacing>
      <div::line/>

      <div::container onClick={onClick}>
        <p::time>
          <{ time }>
        </p>

        <ColoredSquare type={type}/>
      </div>
    </div>
  }
}

component ColoredSquare {
  property type : SquareType

  fun squareTypeToColor (squareType : SquareType) {
    case (squareType) {
      SquareType::Sleep => "purple"
      SquareType::Eat => "red"
      SquareType::Work => "blue"
      SquareType::Necessity => "yellow"
      SquareType::Free => "green"
    }
  }

  style square {
    background: #{squareTypeToColor(type)};
    width: 60px;
    height: 60px;
  }

  fun render : Html {
    <div::square/>
  }
}
