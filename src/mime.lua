local mimetypes = require("mimetypes")

local mime = {}

mime.types = mimetypes.copy()

function mime.get(ext)
   for _, db in pairs(mime.types) do
      local t = db[ext]
      if t then
         return t
      end
   end
   return "application/octet-stream"
end

function mime.guess()
   return mimetypes.guess() or "application/octet-stream"
end

return mime
