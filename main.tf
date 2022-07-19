terraform {
  required_providers {
    minecraft = {
      source  = "hashicraft/minecraft"
      version = "0.1.0"
    }
  }
}

provider "minecraft" {
  address  = "8.tcp.ngrok.io:15246"
  password = "password"
}

resource "minecraft_block" "stone" {
  material = "minecraft:cobblestone"

  position = {
    x = -198
    y = 66
    z = -195
  }
}

// Module that creates a cube out of Minecraft blocks
module "walls" {
  source = "./cube"

  material = "cobblestone"

  position = {
    x = -198,
    y = 68,
    z = -195
  }

  dimensions = {
    width  = 9,
    length = 9,
    height = 4
  }
}

module "inside" {
  source = "./cube"

  material = "air"

  position = {
    x = -197,
    y = 71,
    z = -194
  }

  dimensions = {
    width  = 7,
    length = 7,
    height = 3
  }
}
