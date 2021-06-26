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
    display: block;
    font-family: "Gilroy", sans-serif;
    font-weight: bold;
  }

  style container {
    max-width: 70rem;
    margin: auto;
  }

  style nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    color: #{Colors:BLUE_LOGO};
    border-bottom: 2px #{Colors:RED_LOGO} solid;
  }

  style buttons-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    padding-top: 20px;
    margin-bottom: 40px;
  }

  style squares-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
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
      <div::nav::container>
        <Logo/>
        <h2>"Exercício dos 48 quadrados para gestão de tempo"</h2>
      </div>

      <div::buttons-container::container>
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

      <div::squares-container::container>
        <{ renderSquares(squares) }>
      </div>
    </div>
  }
}

component SelectButton {
  connect SquareStore exposing { setSelectedType }
  property active : Bool
  property type : SquareType

  style select-button {
    display: flex;
    align-items: center;
    padding: 10px;
    border: none;
    text-decoration: none;
    border-radius: 1rem;
    cursor: pointer;
    margin-right: 6px;
    color: #{Colors:BLUE_LOGO};
    font-weight: 700;
    font-size: 1.25rem;
    background: white;

    &:hover {
      background: #{Colors:GRAY_100};
    }

    if (active) {
      border: #{Colors:GRAY_300} 2px solid;
      background: #{Colors:GRAY_100};
    } else {
      border: #00000000 2px solid;
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
    <button::select-button onClick={() { setSelectedType(type) }}>
      <ColoredSquare
        size={30}
        type={type}/>

      <p>
        <{ typeToString(type) }>
      </p>
    </button>
  }
}
