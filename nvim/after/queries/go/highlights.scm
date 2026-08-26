; extends

; A parenthesized pointer to a package member in call position is a type
; conversion, for example: (*encoding.TextUnmarshaler)(value).
(call_expression
  function: (parenthesized_expression
    (unary_expression
      (selector_expression
        field: (field_identifier) @type))))
