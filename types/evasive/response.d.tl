local type types = require("evasive.types")

local type request = require("evasive.request")

local type callback = function(request, response)

local record response
   code:            types.code
   headers:         types.headers
   body:            types.body
   route_not_found: callback

   new:                    function(): response

   set_code:               function(response, types.code):     response
   set_header:             function(response, string, string): response
   set_body:               function(response, types.body):     response
   set_not_found_fallback: function(response, callback):       response
   set_state:              function(response, boolean):        response

   get_code:               function(response):                 types.code
   get_headers:            function(response):                 types.headers
   get_body:               function(response):                 types.body
   get_not_found_fallback: function(response):                 callback
   get_state:              function(response):                 boolean

   not_found:              function(response, request)

   build:                  function():                         (table, string) -- table: lua-http headers, string: lua-http body 
end

return response

