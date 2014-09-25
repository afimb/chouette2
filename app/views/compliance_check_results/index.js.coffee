jQuery ->
  $(".notice")
    .click(-> false) # cancel click on <a> tag
    .popover({ container: "body", html: false, placement: "bottom" })

  # Hide and show error details
  $(".title_error").each ->     
    $( this ).click -> 
      $(this).next(".details_error").toggle()      
      $(this).children("i").toggleClass("fa-plus-square fa-minus-square")