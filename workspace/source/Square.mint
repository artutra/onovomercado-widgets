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
    margin-right: -2px;
  }

  style outline {
    content: "";
    position: absolute;
    inset: 0;
    border: 2px solid #e7004c;
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
  }

  style line {
    padding-top: 30px;
    border-left: 2px solid #e7004c;
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
        onMouseDown={onClick}
        onTouchStart={onClick}
        onTouchEnd={onClick}>

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
