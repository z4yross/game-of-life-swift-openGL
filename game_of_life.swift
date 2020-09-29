
// run: swiftc game_of_life.swift -import-objc-header opengl_includes.h -lglfw -lGL

import Foundation


let len_grid = 1000
var arr = Array(repeating: Array(repeating: 0, count: len_grid), count: len_grid)
var arr1 = Array(repeating: Array(repeating: 0, count: len_grid), count: len_grid)

var ex = 1
var ey = 1

arr[100][100] = 1
arr[100][101] = 1
arr[100][102] = 1

func setup(){
    glEnable(UInt32(GL_BLEND))
    glBlendFunc(UInt32(GL_SRC_ALPHA), UInt32(GL_ONE_MINUS_SRC_ALPHA));

    glClearColor(0, 0, 0, 1)
}

func draw(){
    glClear(UInt32(GL_COLOR_BUFFER_BIT))
    
    glPointSize(10.0);

    glColor4f(1.0, 1.0, 1.0, 0.2)

    grid(len:len_grid)

    glColor4f(1.0, 1.0, 1.0, 1)


    for i in 1...arr.count - 2 {
        for j in 1...arr[0].count - 2 {

            if (arr[i][j] == 1){
                sqr(x: Float(i), y: Float(j), grid_len: len_grid)
            }


            var neib = 0

            neib = arr[i-1][j-1] + arr[i-1][j] + arr[i-1][j+1] + arr[i][j-1] + arr[i][j+1] + arr[i+1][j-1] + arr[i+1][j] + arr[i+1][j+1]

            if (arr[i][j] == 0){
                if (neib == 3){
                    arr1[i][j] = 1 
                }
            }
            else{
                arr1[i][j] = (neib == 3 || neib == 2) ? 1 : 0
            }
        }
    }

    arr = arr1
    arr1 = Array(repeating: Array(repeating: 0, count: len_grid), count: len_grid) 
}

func line(x: Float, y: Float, x1: Float, y1: Float){
    glBegin(UInt32(GL_LINES)); 
        glVertex2f(x, y);
        glVertex2f(x1, y1);
    glEnd();
}

func grid(len: Int){
    for i in 0...len {
        let pos = Float(i) * 2 / Float(len) - 1
        line(x: 1, y: pos, x1: -1, y1: pos)
        line(x: pos, y: 1, x1: pos, y1: -1)
    }
}

func sqr(x: Float, y: Float, grid_len: Int){
    let x_1 = Float(Int(x) % grid_len)
    let y_1 = Float(Int(y) % grid_len)

    let size = 2 / Float(grid_len)

    let pos_x = x_1 * size - 1
    let pos_y = y_1 * size - 1

    glBegin(UInt32(GL_QUADS))
        glVertex2f(pos_x, pos_y)
        glVertex2f(pos_x + size, pos_y)
        glVertex2f(pos_x + size, pos_y + size)
        glVertex2f(pos_x, pos_y + size)
    glEnd()
}






if(glfwInit() == 0) {
    print("Failed to initialize GLFW! I'm out!")
    exit(-1)
}

guard let window = glfwCreateWindow(2000, 2000, "OpenGL test - Swift", nil, nil)
else {
    print("Failed to open a window! I'm out!")
    glfwTerminate()
    exit(-1)
}

glfwMakeContextCurrent(window)

setup()

while (glfwWindowShouldClose(window) == 0) {
    draw()

    glfwSwapBuffers(window)
    glfwPollEvents()
}

glfwDestroyWindow(window)
glfwTerminate()
