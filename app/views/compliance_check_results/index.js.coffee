jQuery ->
  $(".notice").popover({ container: "body", trigger: "click", html: false, placement: "bottom" })

  $("body").click (e) ->
    $(".notice").each ->    
      #the 'is' for buttons that trigger popups
      #the 'has' for icons within a button that triggers a popup
      if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
        if( $(this).data('bs.popover').tip().hasClass('in') )
          $(this).popover('toggle')

  # Hide and show error details
  $(".title_error").each ->     
    $( this ).click -> 
      $(this).next(".details_error").toggle()      
      $(this).children("i").toggleClass("fa-plus-square fa-minus-square")