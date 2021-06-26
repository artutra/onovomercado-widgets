enum Br {
  SM
  MD
  LG
  XL
  XL2
}

module ScreenSize {
  const SM = 640
  const MD = 768
  const LG = 1024
  const XL = 1280

  fun getBreakpoint {
    try {
      width =
        Window.width()

      if (width < 640) {
        Br::SM
      } else if (width < 768) {
        Br::MD
      } else if (width < 1024) {
        Br::LG
      } else if (width < 1280) {
        Br::XL
      } else {
        Br::XL2
      }
    }
  }
}

store Breakpoints {
  state br = ScreenSize.getBreakpoint()

  state listener =
    Window.addEventListener(
      "resize",
      false,
      (event : Html.Event) {
        try {
          currentBr =
            ScreenSize.getBreakpoint()

          if (currentBr != br) {
            next { br = currentBr }
          } else {
            next { }
          }
        }
      })
}
