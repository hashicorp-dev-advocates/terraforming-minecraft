BLOCK_TYPE "BLOCK_LABEL" "BLOCK_LABEL" {
  IDENTIFIER = EXPRESSION
}

resource "resource_type" "identifier" {
  // set a string value
  string_field = "foo"

  // set a number value
  number_field = 42

  // set a list value
  string_list = ["foo", "bar"]
  number_list = [1, 2, 3]

  // set a map value
  map_field = {
    foo = "bar"
  }

  // set a longer string using heredoc
  long_string = <<EOF
  this
  is
  a
  long
  string
  EOF

  // use interpolation to reference other fields, or compute values
  interpolated = "${string_key} is ${number_key}"
}

resource "type" "other" {
  // reference values from other resources
  reference = other_resource.identifier.string_field
}
