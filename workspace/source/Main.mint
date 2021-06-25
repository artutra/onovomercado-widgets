store SquareStore {
  state selectedType : SquareType = SquareType::Free

  state squares : Array(SquareCell) =
    [
      {
        time = "11",
        type = SquareType::Free
      },
      {
        time = "12",
        type = SquareType::Free
      }
    ]

  fun toggleSquare (selectedTime : String) {
    next
      {
        squares =
          squares
          |> Array.map(
            (s : SquareCell) : SquareCell {
              if (s.time == selectedTime) {
                {
                  time = s.time,
                  type = selectedType
                }
              } else {
                s
              }
            })
      }
  }

  fun setSelectedType (newSelectedType : SquareType) {
    next { selectedType = newSelectedType }
  }
}

record SquareCell {
  time : String,
  type : SquareType
}

component Main {
  connect SquareStore exposing { selectedType, squares, setSelectedType }

  style app {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;
    background-color: #282C34;
    height: 100vh;
    width: 100vw;
    font-family: Open Sans;
    font-weight: bold;
  }

  fun renderSquares (squares : Array(SquareCell)) : Array(Html) {
    squares
    |> Array.map(
      (s : SquareCell) : Html {
        <Square
          time={s.time}
          type={s.type}/>
      })
  }

  fun typeToString (type : SquareType) {
    case (type) {
      SquareType::Free => "Livre"
      SquareType::Necessity => "Necessidade"
    }
  }

  fun render : Html {
    <div::app>
      <Logo/>
      <{ typeToString(selectedType) }>

      <button onClick={() { setSelectedType(SquareType::Free) }}>
        "livre"
      </button>

      <button onClick={() { setSelectedType(SquareType::Necessity) }}>
        "necessidade"
      </button>

      <Info mainPath="source/Main.mint"/>
      <{ renderSquares(squares) }>
    </div>
  }
}
