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

resource "minecraft_block" "stone" {
  material = "minecraft:stone"

  position = {
    x = -198
    y = 66
    z = -195
  }
}
