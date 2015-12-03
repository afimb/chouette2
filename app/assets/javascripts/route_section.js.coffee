class @RouteSectionMap
  @onSelectedFeature: (feature) ->
    route_section_id = feature.data.id

    routeSectionOption = $("option[value=#{route_section_id}]")
    routeSectionOption.parent().val route_section_id
    RouteSectionMap.changeStyle(routeSectionOption.parent())

    $('#map-selection').show()
    $('#empty-map-selection').hide()

    selectionUrl = location.pathname.replace /edit$/, "selection"
    $.ajax(url: selectionUrl, method: 'POST', data: { route_section_id: route_section_id }, dataType: 'html').done (data) ->
      $('#map-selection div').replaceWith(data)

  @onUnselectedFeature: (feature) ->
    $('#map-selection').hide()
    $('#empty-map-selection').show()

  @editRoute = (el) ->
    new_route_section_id = $(el).val()
    edit_link = $(el).closest("tr").find("a.edit-route-section")

    # Save edit link to play with it
    unless edit_link.data("href-pattern")?
      edit_link.data "href-pattern", edit_link.attr('href').replace(new RegExp("/route_sections/([0-9]+)/edit"), "/route_sections/:id/edit")

    if !!new_route_section_id
      edit_link.removeClass "disabled"
      edit_link.attr 'href', edit_link.data("href-pattern").replace(/:id/, new_route_section_id)
    else
      edit_link.addClass "disabled"
      edit_link.attr 'href', '#'

  @featureStyle = (id, erase) ->
    if id
      features = route_section_geometry.getFeaturesByAttribute('id', id.toString())
      if features.length > 0
        feature = features[0]
        style = null
        if !erase
          style =
            strokeWidth: 3
            strokeColor: 'green'
        feature.style = style
        feature.layer.redraw()

  @changeStyle = (el) ->
    id = $(el).val()
    options = $(el).find('option').map(->
      $(this).val()
    )
    $.each options, (key, value) ->
      RouteSectionMap.featureStyle value, true
      return
    RouteSectionMap.featureStyle id, false

jQuery ->
  $route_sections_selector = $('[name^="route_sections_selector[sections_attributes]"]')
  $.each $route_sections_selector, (index, el) ->
    RouteSectionMap.changeStyle el

  if $("#map.route_section").length > 0 and user_geometry?
    projWGS84 = new OpenLayers.Projection("EPSG:4326")
    proj900913 = new OpenLayers.Projection("EPSG:900913")
    wtk_format = new OpenLayers.Format.WKT()

    user_geometry.events.on({
      afterfeaturemodified: (event) ->
        wgs84_geometry = event.feature.geometry.transform(proj900913, projWGS84)
        wgs84_feature = new OpenLayers.Feature.Vector(wgs84_geometry)
        ewtk = "SRID=4326;#{wtk_format.write(wgs84_feature)}"

        $('#route_section_editable_geometry').val(ewtk)
        return
    })

  $('#new_route_sections_selector select').on 'change', ->
    RouteSectionMap.changeStyle this
    RouteSectionMap.editRoute this

  $('form.route_section').find('button[type="submit"]').on 'click', (e) ->
    e.preventDefault();
    if typeof modify_feature != 'undefined'
      modify_feature.deactivate()
    $('form.route_section').submit()
    return

  return
