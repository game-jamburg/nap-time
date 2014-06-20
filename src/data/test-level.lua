return define(Scene) "scene" {
    define(Entity) "data" {
        define(Transform) "transform" {
            position = Vector:new(400, 300),
            rotation = 0,
        },
        define(Sprite) "sprite" {
            image = "blur.png",
            color = Color.Yellow,
            scaleFactor = 2
        }
    }
}
