import glfum, opengl

var
  program:GLuint = 0
  vertexBuffer:GLuint = 0
  vertexArray:GLuint = 0

proc onDraw(display: ptr GLFMDisplay) {.cdecl,exportc.}
proc onSurfaceDestroyed(display: ptr GLFMDisplay) {.cdecl,exportc.}

proc glfmMain*(display: ptr GLFMDisplay) {.exportc.} =
  glfmSetDisplayConfig(display,
                       GLFMRenderingAPIOpenGLES2,
                       GLFMColorFormatRGBA8888,
                       GLFMDepthFormatNone,
                       GLFMStencilFormatNone,
                       GLFMMultisampleNone)
  discard glfmSetRenderFunc(display, onDraw)
  discard glfmSetSurfaceDestroyedFunc(display, onSurfaceDestroyed)

proc onSurfaceDestroyed(display: ptr GLFMDisplay) {.cdecl,exportc.} =
  program = 0;
  vertexBuffer = 0;
  vertexArray = 0;

proc compileShader(`type`: GLenum, shaderString: cstring, shaderLength: GLint): GLuint =
  result = glCreateShader(`type`)
  var shaderString = shaderString
  var shaderLength = shaderLength
  glShaderSource(result, 1, cast[cstringArray](shaderString.addr), shaderLength.addr)
  glCompileShader(result)

#template toGL*(str: static[cstring]): array[str.len, GLint] =
#  cast[array[str.len, GLint]](str)

proc onDraw(display: ptr GLFMDisplay) {.cdecl,exportc.} =
    if program == 0:
      const vertexShader = """
#version 100
attribute highp vec4 position;
void main() {"
   gl_Position = position;"
}
"""

      const fragmentShader = """
version 100
void main() {
  gl_FragColor = vec4(1.00, 1.00, 1.00, 1.0)
}
"""

      program = glCreateProgram()
      let vertShader = compileShader(GL_VERTEX_SHADER, vertexShader, vertexShader.len - 1)
      let fragShader = compileShader(GL_FRAGMENT_SHADER, fragmentShader, fragmentShader.len - 1)

      glAttachShader(program, vertShader)
      glAttachShader(program, fragShader)

      glLinkProgram(program)

      glDeleteShader(vertShader)
      glDeleteShader(fragShader)

    if vertexBuffer == 0:
      var vertices = [
         0.0,  0.5, 0.0,
        -0.5, -0.5, 0.0,
         0.5, -0.5, 0.0
      ]
      glGenBuffers(1, vertexBuffer.addr);
      glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer)
      glBufferData(GL_ARRAY_BUFFER, vertices.len, vertices.addr, GL_STATIC_DRAW)

    var width, height: cint
    glfmGetDisplaySize(display, width.addr, height.addr)
    glViewport(0, 0, width, height)
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
    glClear(GL_COLOR_BUFFER_BIT)

    when defined(GL_VERSION_3_0):
      when GL_VERSION_3_0:
        if vertexArray == 0:
          glGenVertexArrays(1, vertexArray.addr);
        glBindVertexArray(vertexArray);

    glUseProgram(program)
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer)

    glEnableVertexAttribArray(0)
    glVertexAttribPointer(0, 3, cGL_FLOAT, GL_FALSE, 0, nil)
    glDrawArrays(GL_TRIANGLES, 0, 3)

    glfmSwapBuffers(display)

