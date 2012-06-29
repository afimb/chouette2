/* French initialisation for the jQuery UI date picker plugin. */
/* Written by Keith Wood (kbwood{at}iinet.com.au) and Stéphane Nahmani (sholby@sholby.net). */
jQuery(function($){

	$.datepicker.regional['fr'] = {
		closeText: 'Fermer',
		prevText: '&#x3c;Préc',
		nextText: 'Suiv&#x3e;',
		currentText: 'Courant',
		monthNames: ['Janvier','Février','Mars','Avril','Mai','Juin',
		'Juillet','Août','Septembre','Octobre','Novembre','Décembre'],
		monthNamesShort: ['Jan','Fév','Mar','Avr','Mai','Jun',
		'Jul','Aoû','Sep','Oct','Nov','Déc'],
		dayNames: ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'],
		dayNamesShort: ['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'],
		dayNamesMin: ['Di','Lu','Ma','Me','Je','Ve','Sa'],
		weekHeader: 'Sm',
		dateFormat: 'dd/mm/yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};

    $.datepicker.regional['en'] = {
		closeText: 'Done',
		prevText: 'Prev',
		nextText: 'Next',
		currentText: 'Today',
		monthNames: ['January','February','March','April','May','June',
		'July','August','September','October','November','December'],
		monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
		'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
		dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
		dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'],
		weekHeader: 'Wk',
		dateFormat: 'dd/mm/yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
    
    if(!(Modernizr.inputtypes && Modernizr.inputtypes.date))
    {
        $.datepicker.setDefaults($.datepicker.regional[ "" ]);
        $("input[type='date']").each( function(index, element)
                                      {
                                          $(element).datepicker(
                                              { 
                                                  dateFormat: "dd/mm/y",
                                                  dayNamesShort: $.datepicker.regional[ $('html').attr('lang') ].dayNamesShort, 
                                                  dayNames: $.datepicker.regional[ $('html').attr('lang') ].dayNames, 
                                                  monthNamesShort: $.datepicker.regional[ $('html').attr('lang') ].monthNamesShort, 
                                                  monthNames: $.datepicker.regional[ $('html').attr('lang') ].monthNames
                                              } );
                                          $(element).datepicker("setDate", $.datepicker.parseDate('yy-mm-dd', $(element).val() ) );
                                      });

        $("form").submit(function(event) {
            var $this = $(event.target);
            $this.find("input[type='date']").each( 
                function(index, element)
                {
                    var date = $.datepicker.formatDate('yy-mm-dd', $.datepicker.parseDate('dd/mm/y', $(element).val() ) );                   
                    $(element).val(date);
                }
            );
        });
    }

});
