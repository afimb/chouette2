$(".stop_areas.index").ready ->
  # Autocomplete input to choose postal code in stop_areas index
  # constructs the suggestion engine
  if $('#country_codes').length > 0
    country_codes = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      local: $.map( JSON.parse($('#country_codes').text() ), (country_code) ->
        value: country_code
      )
    )
    country_codes.initialize()
    # kicks off the loading/processing of `local` and `prefetch`
    $('#search .typeahead').typeahead(
      {
        hint: true,
        highlight: true,
        minLength: 1
      },
      {
        name: 'country_codes',
        displayKey: 'value',
        source: country_codes.ttAdapter(),
      }
    )
