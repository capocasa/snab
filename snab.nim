import os

import sdl2
import sdl2/ttf


proc writeHello(renderer: RendererPtr, font: FontPtr) =
  let
    color = color(255, 255, 255, 255)
    text = "Hello, World!" 
    surface = ttf.renderTextSolid(font, cstring text, color)
    texture = renderer.createTextureFromSurface(surface)

  surface.freeSurface

  var r = rect(50, 50, 320, 100)

  renderer.copy texture, nil, r.addr
  texture.destroy

proc main() =
  discard sdl2.init(INIT_EVERYTHING)

  var
    window: WindowPtr
    renderer: RendererPtr

  window = createWindow("snab", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 480,640, SDL_WINDOW_RESIZABLE)
  discard window.setFullscreen(1)
  renderer = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

  var
    evt = sdl2.defaultEvent
    run = true
  
  if not ttfInit():
    echo "snab: could not initialize ttf"
    run = false

  let font = ttf.openFont("liberation-sans.ttf", 32)
  if font.isNil:
    echo "snab: could not create font"
    run = false

  while run:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        run = false
        break

    renderer.setDrawColor 0,0,0,255
    renderer.clear
    
    renderer.writeHello font

    renderer.present


  ttfQuit()
  destroy renderer
  destroy window

proc NimMain() {.importc.}
proc SDL_main(argc: cint, argv: openArray[char]):int {.cdecl,exportc,dynlib.} =
  NimMain()
  main()


