local type types = require("evasive.types")

local type request = require("evasive.request")

local record response
   code:            types.code
   headers:         types.headers
   body:            types.body

   new:         function(): response

   set_code:    function(response, types.code):     response
   set_header:  function(response, string, string): response
   set_body:    function(response, types.body):     response

   get_code:    function(response):                 types.code
   get_headers: function(response):                 types.headers
   get_body:    function(response):                 types.body

   build:       function():                         (table, string) -- table: lua-http headers, string: lua-http body 
end

return response

