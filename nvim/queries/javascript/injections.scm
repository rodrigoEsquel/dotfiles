(string (string_fragment) @injection.content
 (#vim-match? @injection.content "^(SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER|select|from|inner join|where|create|drop|insert|update|alter)")
 (#set! injection.language "sql"))

(template_string (string_fragment) @injection.content
 (#vim-match? @injection.content "^(SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER|select|from|inner join|where|create|drop|insert|update|alter)")
 (#set! injection.language "sql"))
