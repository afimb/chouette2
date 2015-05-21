module BootstrapHelper

  def bh_label(content, options = {})
    options = { variation: "default" }.merge(options)
    content_tag :span, content, class: "label label-#{options[:variation]}"
  end

end
