# `evasive`

A Lua web framework, running on top of [lua-http](https://github.com/daurnimator/lua-http/).

## Installation

Using Luarocks:
```sh
$ luarocks install evasive
```

## Example

Using Lua:
```lua
local router = require("evasive.router")
local mime = require("evasive.mime")

router:new({host = "127.0.0.1", port = 8080})
:add_route("GET", "/", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("txt"))
   :set_body("Welcome home")
end)
:start()
```

Using Teal:
```lua
local router = require("evasive.router")
local mime = require("evasive.mime")
local request = require("evasive.request")
local response = require("evasive.response")

router:new({host = "127.0.0.1", port = 8080})
:add_route("GET", "/", function(req: request, res: response)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("txt"))
   :set_body("Welcome home")
end)
:start()
```

## Documentation

## License

`evasive` is written under MIT.
See the [license](https://www.github.com/code-nuage/evasive/blob/main/LICENSE) file.

## Contributing

Contributions are welcome, especially:
- bug fixes
- documentation improvements

A todo list is provided [here](https://www.github.com/code-nuage/evasive/blob/main/TODO.md).
