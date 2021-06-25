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
    justify-content: center;
    padding-top: 20px;
    margin-bottom: 40px;
  }

  style squaresContainer {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    padding-left: 20px;
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
        <SelectButton
          type={type}
          active={selectedType == type}/>
      })
  }

  fun render : Html {
    <div::app>
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

component SelectButton {
  connect SquareStore exposing { setSelectedType }
  property active : Bool
  property type : SquareType

  style selectButton {
    display: flex;
    align-items: center;
    padding: 10px;
    border: none;
    text-decoration: none;
    border-radius: 5px;
    cursor: pointer;
    margin-right: 6px;

    &:hover {
      background: #{Colors:GRAY_100};
    }

    if (active) {
      border: #0000005c 2px solid;
    } else {

    }

    p {
      margin-left: 10px;
    }
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

  fun render {
    <button::selectButton onClick={() { setSelectedType(type) }}>
      <ColoredSquare
        size={30}
        type={type}/>

      <p>
        <{ typeToString(type) }>
      </p>
    </button>
  }
}
