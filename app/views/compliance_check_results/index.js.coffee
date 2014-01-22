jQuery ->
  $("body").popover({ selector: '.notice', container: "body", trigger: "click", html: true, placement: "bottom" })

  # Hide and show error details
  $(".title_error").each ->     
    $( this ).click -> 
      $(this).next(".details_error").toggle()      
      $(this).children("i").toggleClass("fa-plus-square fa-minus-square")