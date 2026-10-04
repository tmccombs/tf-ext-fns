run "bool2num" {
  assert {
    condition     = output.bool2num.t == 1
    error_message = "bool2num(true) is not 1"
  }
  assert {
    condition     = output.bool2num.f == 0
    error_message = "bool2num(false) is not 0"
  }
}

run "bool2set" {
  assert {
    condition     = output.bool2set.t == toset([""])
    error_message = "bool2set(true) is not set of single empty string"
  }
  assert {
    condition     = output.bool2set.f == convert([], set(string))
    error_message = "bool2set(false) is not empty"
  }
}

run "repeat" {
  assert {
    condition     = output.repeat.empty == tolist([])
    error_message = "Failed to creat empty array with count of 0"
  }

  assert {
    condition     = output.repeat.once == tolist([4])
    error_message = "Incorrect value for repeat(4, 1)"
  }

  assert {
    condition     = output.repeat.many == tolist(["a", "a", "a", "a"])
    error_message = "Incorrect value for repeat(\"a\", 4)"
  }
}

run "map_splat" {
  assert {
    condition     = output.map_splat.xs == tomap({ a = 1, b = 2, c = 51 })
    error_message = "Failed to splat x values"
  }

  assert {
    condition     = output.map_splat.first == tomap({ a = 2, b = 4, c = 7 })
    error_message = "Failed to splat index into array"
  }
}

run "regex_test" {
  assert {
    condition     = output.regex_test.match
    error_message = "match"
  }
  assert {
    condition     = output.regex_test.multi
    error_message = "multiple matches"
  }
  assert {
    condition     = !output.regex_test.none
    error_message = "no matches"
  }
}

# run "dig" {
#   assert {
#     condition     = output.dig.value1 == "value"
#     error_message = "Failed to look up existing value"
#   }
#
#   assert {
#     condition     = output.dig.null == null
#     error_message = "Didn't return null for intermediate null value"
#   }
#
#   assert {
#     condition     = output.dig.non_existant == null
#     error_message = "Didn't return null for non-existant value"
#   }
# }

run "coalesce" {
  assert {
    condition     = output.coalesce.all_null == convert(null, string)
    error_message = "didn't get null for all null args to coalesce"
  }

  assert {
    condition     = output.coalesce.non_null_first == 1
    error_message = "non-null first"
  }

  assert {
    condition     = output.coalesce.non_null_last == 3
    error_message = "non-null last"
  }
}

run "filter_keys" {
  assert {
    condition     = output.filter_keys.single == { b = "two" }
    error_message = "single key"
  }
  assert {
    condition     = output.filter_keys.two == { a = "one", c = "three" }
    error_message = "two keys"
  }
  assert {
    condition     = output.filter_keys.obj == { a = 1, b = "s" }
    error_message = "two keys"
  }
}
