import sdl2


proc main() =
  discard sdl2.init(INIT_EVERYTHING)

  var
    window: WindowPtr
    render: RendererPtr

  window = createWindow("snab", 100, 100, 640,480, SDL_WINDOW_SHOWN)
  render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

  var
    evt = sdl2.defaultEvent
    run = true

  while run:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        run = false
        break

    render.setDrawColor 0,0,0,255
    render.clear
    render.present

  destroy render
  destroy window

proc NimMain() {.importc.}
proc SDL_main(argc: cint, argv: openArray[char]):int {.cdecl,exportc,dynlib.} =
  NimMain()
  main()


