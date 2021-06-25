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
  property borderColor = Colors:RED_500

  style container {
    position: relative;
    padding: 10px;
    margin-right: -2px;
  }

  style outline {
    content: "";
    position: absolute;
    inset: 0;
    border: 2px solid #{borderColor};
  }

  style spacing {
    padding-top: 30px;
    padding-bottom: 20px;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -o-user-select: none;
    user-select: none;
  }

  style time {
    position: absolute;
    padding: 0;
    margin: 0;
    top: -60px;
    left: -20px;
    color: Colors:GRAY_600;
  }

  style line {
    padding-top: 30px;
    border-left: 2px solid #{borderColor};
  }

  fun onClick {
    toggleSquare(time)
  }

  fun onMouseOver (e : Html.Event) : Promise(Never, Void) {
    if (e.buttons == 1 || e.type == "touchmove") {
      toggleSquare(time)
    } else {
      Promise.never()
    }
  }

  fun render : Html {
    <div::spacing>
      <div::line/>

      <div::container
        onMouseOver={onMouseOver}
        onMouseDown={onClick}>

        <p::time>
          <{ time }>
        </p>

        <div::outline/>
        <ColoredSquare type={type}/>

      </div>
    </div>
  }
}

component ColoredSquare {
  property type : SquareType
  property size = 60

  fun squareTypeToColor (squareType : SquareType) {
    case (squareType) {
      SquareType::Sleep => Colors:PURPLE_700
      SquareType::Eat => Colors:RED_500
      SquareType::Work => Colors:BLUE_500
      SquareType::Necessity => Colors:YELLOW_500
      SquareType::Free => Colors:GREEN_500
    }
  }

  style square {
    background: #{squareTypeToColor(type)};
    width: #{size}px;
    height: #{size}px;
  }

  fun render : Html {
    <div::square/>
  }
}
