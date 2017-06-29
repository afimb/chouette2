object @destination_display

node do |destination_display|
  {
  :id => destination_display.id,
  :name => destination_display.name || "",
  :front_text => destination_display.front_text || "",
  :side_text => destination_display.side_text || ""
  }
end
