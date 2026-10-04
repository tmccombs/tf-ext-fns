language {
  compatible_with {
    opentofu = ">=1.13"
  }
  experiments = [symbol_libraries]
}

symbols "ext" {
  source = "./.."
}

locals {
  m = {
    a = {
      x = 1
      y = 2
    }
    b = {
      x = 2
      y = 3
    }
    c = {
      x = 51
      y = 42
    }
  }
  ma = {
    a = [1, 2]
    b = [3, 4, 5]
    c = [6, 7]
  }

  ms = {
    a = "one"
    b = "two"
    c = "three"
  }

  obj = {
    a = 1
    b = "s"
    c = null
    d = []
  }


  #dig
  deep = {
    a = {
      b = {
        c = "value"
      }
      n = null
    }
  }
}

output "bool2num" {
  value = {
    t = symbols::ext::bool2num(true)
    f = symbols::ext::bool2num(false)
  }
}

output "bool2set" {
  value = {
    t = symbols::ext::bool2set(true)
    f = symbols::ext::bool2set(false)
  }
}

output "repeat" {
  value = {
    empty = symbols::ext::repeat(5, 0)
    once  = symbols::ext::repeat(4, 1)
    many  = symbols::ext::repeat("a", 4)
  }
}

output "map_splat" {
  value = {
    xs    = symbols::ext::map_splat(local.m, "x")
    first = symbols::ext::map_splat(local.ma, 1)
  }
}

output "regex_test" {
  value = {
    match = symbols::ext::regex_test("[cbf]o*d", "cod")
    multi = symbols::ext::regex_test("[cbf]o*d?", "cod foo boo food")
    none  = symbols::ext::regex_test("^arn", "glue")
  }
}

output "coalesce" {
  value = {
    all_null       = symbols::ext::coalesce(convert([null, null, null, null], list(string))...)
    non_null_first = symbols::ext::coalesce(1, tonumber(null))
    non_null_last  = symbols::ext::coalesce(tonumber(null), tonumber(null), 3)
  }
}

output "filter_keys" {
  value = {
    single = symbols::ext::filter_keys(local.ms, "b")
    two    = symbols::ext::filter_keys(local.ms, "a", "c")
    obj    = symbols::ext::filter_keys(local.obj, "a", "b")
  }
}

# output "deep_merge" {
#   value = symbols::ext::deep_merge({
#     a = {
#       b = {
#         c = "deep"
#       }
#     }
#   }, local.deep)
# }

# output "dig" {
#   value = {
#
#     value1       = symbols::ext::dig(local.deep, "a", "b", "c")
#     null         = symbols::ext::dig(local.deep, "a", "n", "z")
#     non_existant = symbols::ext::dig(local.deep, "b", "r")
#   }
# }
