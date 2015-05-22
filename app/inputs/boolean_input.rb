class BooleanInput < Formtastic::Inputs::BooleanInput
  def label_with_nested_checkbox
    builder.label(
      method,
      label_text,
      label_html_options.merge(class: "label")
    ) << "" << check_box_html
  end
end
