terraform {
  required_providers {
    minecraft = {
      source  = "hashicraft/minecraft"
      version = "0.1.0"
    }
  }
}

provider "minecraft" {
  address  = "localhost:27015"
  password = "password"
}

// Module that creates a cube out of Minecraft blocks
module "walls" {
  source = "./cube"

  material = "stone"

  position = {
    x = 98,
    y = 66,
    z = -126
  }

  dimensions = {
    width  = 9,
    length = 9,
    height = 4
  }
}

module "inside" {
  depends_on = [
    module.walls
  ]

  source = "./cube"

  material = "air"

  position = {
    x = module.walls.origin.x + 1,
    y = module.walls.origin.y + 1,
    z = module.walls.origin.z + 1
  }

  dimensions = {
    width  = 7,
    length = 7,
    height = 3
  }
}

resource "minecraft_block" "furnace" {
  depends_on = [
    module.inside
  ]

  material = "minecraft:furnace"

  position = {
    x = -196
    y = 69
    z = -188
  }
}

resource "minecraft_block" "chest" {
  depends_on = [
    module.inside
  ]

  material = "minecraft:chest"

  position = {
    x = -195
    y = 69
    z = -188
  }
}
