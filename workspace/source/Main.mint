record SquareCell {
  time : String,
  type : SquareType
}

record StoredCell {
  time : String,
  type : String
}

store SquareStore {
  state selectedType : SquareType = SquareType::Free
  state squares : Array(SquareCell) = SquareConstants:INIT

  fun initialize : Promise(Never, Void) {
    try {
      data =
        Storage.Local.get("squares")

      object =
        Json.parse(data)
        |> Maybe.toResult("")

      storedSquares =
        decode object as Array(StoredCell)

      loadedSquares =
        storedSquares
        |> Array.map(storedCellToSquareCell)

      next { squares = loadedSquares }
    } catch Storage.Error => error {
      next { squares = SquareConstants:INIT }
    } catch Object.Error => error {
      next { squares = SquareConstants:INIT }
    } catch String => error {
      next { squares = SquareConstants:INIT }
    }
  }

  fun storeSquares (newSquares : Array(SquareCell)) : Promise(Never, Void) {
    sequence {
      storedSquares =
        newSquares
        |> Array.map(squareCellToStoredCell)

      Storage.Local.set("squares", Json.stringify(encode storedSquares))
      next { squares = newSquares }
    } catch Storage.Error => error {
      next { squares = newSquares }
    }
  }

  fun storedCellToSquareCell (sc : StoredCell) : SquareCell {
    {
      time = sc.time,
      type = stringToSquareType(sc.type)
    }
  }

  fun squareCellToStoredCell (sc : SquareCell) : StoredCell {
    {
      time = sc.time,
      type = squareTypeToString(sc.type)
    }
  }

  fun stringToSquareType (s : String) {
    case (s) {
      "sleep" => SquareType::Sleep
      "eat" => SquareType::Eat
      "work" => SquareType::Work
      "necessity" => SquareType::Necessity
      "free" => SquareType::Free
      => SquareType::Free
    }
  }

  fun squareTypeToString (s : SquareType) {
    case (s) {
      SquareType::Sleep => "sleep"
      SquareType::Eat => "eat"
      SquareType::Work => "work"
      SquareType::Necessity => "necessity"
      SquareType::Free => "free"
    }
  }

  fun toggleSquare (selectedTime : String) {
    try {
      newSquares =
        squares
        |> Array.map(
          (s : SquareCell) : SquareCell {
            if (s.time == selectedTime) {
              { s | type = selectedType }
            } else {
              s
            }
          })

      storeSquares(newSquares)
    }
  }

  fun setSelectedType (newSelectedType : SquareType) {
    next { selectedType = newSelectedType }
  }
}

component Main {
  connect SquareStore exposing { selectedType, squares, setSelectedType }
  connect Breakpoints exposing { br }

  style app {
    display: block;
    font-weight: bold;

    * {
      font-family: "Gilroy", sans-serif;
    }
  }

  style container {
    margin: auto;

    case (br) {
      Br::SM =>

      Br::MD =>
        max-width: #{ScreenSize:SM}px;

      Br::LG =>
        max-width: #{ScreenSize:MD}px;

      Br::XL =>
        max-width: #{ScreenSize:LG}px;

      Br::XL2 =>
        max-width: #{ScreenSize:XL}px;
    }
  }

  style nav {
    case (br) {
      Br::SM =>
        flex-direction: column;
        align-items: center;

      => flex-direction: row;
    }

    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 0 1rem 0;

    h1 {
      font-size: 1.75rem;
      text-align: center;
      color: #{Colors:BLUE_LOGO};

      case (br) {
        Br::SM =>
          padding-left: 1rem;
          padding-right: 1rem;

        =>
      }
    }
  }

  style separator {
    display: flex;
    justify-content: stretch;
    align-items: stretch;

    div {
      flex: 1;

      case (br) {
        Br::SM =>
          margin: 0 1rem 0 1rem;

        => margin: 0;
      }

      border-top-width: 0;
      border-right-width: 0;
      border-left-width: 0;
      border-bottom: 2px #{Colors:RED_LOGO} solid;
    }
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
    padding-left: 20px;

    case (br) {
      Br::SM => justify-content: center;
      => justify-content: flex-start;
    }
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
        <h1>"Exercício dos 48 quadrados para gestão de tempo"</h1>
      </div>

      <div::separator::container>
        <div/>
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
    padding: 1rem;
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
      margin: 0 0 0 10px;
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
