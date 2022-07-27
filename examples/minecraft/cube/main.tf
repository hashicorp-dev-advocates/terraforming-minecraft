variable "position" {
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "dimensions" {
  type = object({
    width  = number
    length = number
    height = number
  })
}

variable "material" {
  type = string
}

terraform {
  required_providers {
    minecraft = {
      source  = "hashicraft/minecraft"
      version = "0.1.0"
    }
  }
}

locals {
  // range(start, end) => returns a list of values from start to end

  // this gives us the x values like [0, 1, 2, ...]
  x_values = range(var.position.x, var.position.x + var.dimensions.width)

  // this gives us the y values like [0, 1, 2, ...]
  y_values = range(var.position.y, var.position.y + var.dimensions.height)

  // this gives us the z values like [0, 1, 2, ...]
  z_values = range(var.position.z, var.position.z + var.dimensions.length)

  // setproduct([a,b,c], [x,y,z]) => returns a list with all possible combinations of a,b,c and x,y,z

  // this gives us the coordinates like [[0, 0, 0], [1, 0, 0], [1, 1, 0], ...]
  coordinates = setproduct(local.x_values, local.y_values, local.z_values)

  // zipmap(["a","b","c"], [1,2,3]) => returns an object with keys of the first array and values of the second array: e.g. {"a": 1, "b": 2, "c": 3}

  // this gives a list of objects like [{ "x": 0, "y": 0, "z": 0}, { "x": 1, "y": 0, "z": 0}, {"x": 1, "y": 1, "z": 0}, ...]
  blocks = [for coordinate in local.coordinates : zipmap(["x", "y", "z"], coordinate)]

  // minecraft expects materials to be prefixed with a namespace, so in case one is not specified it is prefixed with the default "minecraft" namespace

  // this gives us a string like "minecraft:stone"
  material = length(regexall("^[a-z]+:[a-z]+$", var.material)) > 0 ? var.material : format("%s:%s", "minecraft", var.material)
}

resource "minecraft_block" "cube" {
  // loop over the blocks and set the index as the id
  for_each = { for i, o in local.blocks : "block-${i}" => o }

  // use the computed material as the material
  material = local.material

  // use the position of each block as its position
  position = {
    x = each.value.x,
    y = each.value.y,
    z = each.value.z
  }
}

// return the origin of the cube so we can reference it in other resources
output "origin" {
  value = var.position
}
