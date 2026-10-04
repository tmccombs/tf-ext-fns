language {
  edition = experimental2026
}

# Convert a boolean to a number
#
# true becomes 1 and false becomes 0
function "bool2num" {
  type = number

  parameter "b" {
    type = bool
  }

  return = param.b ? 1 : 0
}

# TODO: better name?
# Create a set that contains a single element (an empty string) if the
# parameter is true, or no elements if it is false
#
# This is useful for the for_each argument for dynamic blocks to conditionally create
# a single instance of it.
#
function "bool2set" {
  type = set(string)

  parameter "b" {
    type = bool
  }

  return = param.b ? [""] : []
}

# Create an array that repeats a value `count` times.
function "repeat" {
  type = list(any)

  parameter "value" {
    type = any
  }

  parameter "count" {
    type = number

    validation {
      condition = param.count >= 0 && param.count == floor(param.count)
      error_message = "count must be a non-negative integer"
    }
  }

  return = [for _ in range(param.count): param.value]
}


# Projects a lookup on all values of a map
#
# Equivalent to:
#
# {for k, v in root: k => v[key]}
function "map_splat" {
  type = map(any)

  parameter "root" {
    type = map(any)
  }

  # support multiple keys?
  # maybe use dig?
  parameter "key" {
    type = string
  }

  return = {for k, v in param.root: k => v[param.key]}
}

# Perform multiple lookups on an object, and return null
# if any of them are null, or the key doesn't exist on the object
# TODO: can't currently implement due to lack of recursion
# function "dig" {
#   type = any
#
#   parameter "root" {
#     type = any
#   }
#
#   parameter "key" {
#     # Really string | number
#     # but the type system doesn't support that
#     type = string
#     variadic = true
#   }
#
#   locals {
#     len = length(param.key)
#   }
#
#   # this could probably be implemented better in a provider...
#   return = param.root == null || local.len < 1 ? param.root : one([
#     for first in slice(param.key, 0, 1):
#     symbols::dig(try(param.root[first], null), slice(param.key, 1, local.len)...)
#   ])
# }

# Test if a regex matches a string
function "regex_test" {
  type = bool

  parameter "pattern" {
    type = string
  }

  parameter "str" {
    type = string
  }

  return = length(regexall(param.pattern, param.str)) != 0
}


# Like builtin coalesce, but allows last value to be null
# Unfortunately, I don't think this can take lazy values
#
# Due to a limitation of OpenTofu, passing a null literal to this does not work,
# and
function "coalesce" {
  type = any

  parameter "value" {
    type = any
    variadic = true
  }


  # this could probably also be implemented better in a providers
  return = try(coalesce(param.value...), null)
}

function "filter_keys" {
  # We want this to work on objects and maps
  # but there isn't a way to express that
  type = any

  parameter "obj" { type = any }

  parameter "key" {
    type = string
    variadic = true
  }

  return = {
    for k, v in param.obj:
    k => v if contains(param.key, k)
  }
}

# function "deep_merge" {
#   type = any
#
#   parameter "a" { type = any }
#   parameter "b" { type = any }
#
#   locals {
#     both_maps = can(keys(param.a)) && can(keys(param.b))
#   }
#
#   return = (local.both_maps ? {
#     for k in setunion(keys(param.a), keys(param.b)):
#     k => (can(param.a[k]) && can(param.b[k]) ?
#       symbols::deep_merge(param.a[k], param.b[k]) :
#       try(param.b[k], param.a[k]))
#     } : param.b) # non-object/map always take second value
# }
