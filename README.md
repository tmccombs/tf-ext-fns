This is an experimental extension library for [OpenTofu] using the experimental [symbols library] feature.

It provides a collection of functions that I wished were in OpenTofu, including:

- `bool2num` to convert a boolean to a number
- `bool2set` that converts true to a single elemetn set and false to an empty set
- `repeat` that creates a list of a repeated value
- `map_splat` that extracts a specific key or index from each object or list value from a map
- `regex_test` to test if a string matches a regex
- `coalesce` like the builtin `coalesce` except allow all values to be null
- `filter_keys` to filter a map or object to conatin a subset of the keys

[OpenTofu]: https://opentofu.org
[symbols library]: https://opentofu.org/docs/v1.13/language/symbol-libraries/

## Testing

To test this run `tofu test` from inside the `test` directory.


