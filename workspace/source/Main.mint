store SquareStore {
  state selectedType : SquareType = SquareType::Free
  state squares : Array(SquareCell) = SquareConstants:INIT

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
    font-family: Open Sans;
    font-weight: bold;
  }

  style buttonsContainer {
    display: flex;
    flex-wrap: wrap;
  }

  style squaresContainer {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
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

  fun renderButtons (allTypes : Array(SquareType)) {
    allTypes
    |> Array.map(
      (type : SquareType) : Html {
        <button onClick={() { setSelectedType(type) }}>
          <ColoredSquare type={type}/>
          <{ typeToString(type) }>
        </button>
      })
  }

  fun typeToString (type : SquareType) {
    case (type) {
      SquareType::Sleep => "Dormir"
      SquareType::Eat => "Comer"
      SquareType::Work => "Trabalhar"
      SquareType::Necessity => "Necessidades"
      SquareType::Free => "Tempo Livre"
    }
  }

  fun render : Html {
    <div::app>
      <{ typeToString(selectedType) }>

      <div::buttonsContainer>
        <{
          renderButtons(
            [
              SquareType::Sleep,
              SquareType::Eat,
              SquareType::Work,
              SquareType::Necessity,
              SquareType::Free
            ])
        }>
      </div>

      <div::squaresContainer>
        <{ renderSquares(squares) }>
      </div>
    </div>
  }
}
