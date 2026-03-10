local record colors
   method: {string, string}
   code: {integer, string}

   colorize: function(string): string
   colorize_method: function(string, ? string): string
   colorize_code: function(integer, ? string): string
end

return colors
