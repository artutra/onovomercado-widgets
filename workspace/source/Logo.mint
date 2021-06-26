component Logo {
  style logo {
    svg {
      height: 50px;
    }
  }

  fun render : Html {
    <div::logo>
      <{ @svg(logo-onm.svg) }>
    </div>
  }
}
