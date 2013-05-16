module CreationHelper

  def creation_tag(object)
    field_set_tag t("layouts.creation_tag.title") do
      content_tag :ul do
        [(content_tag :li do
          object.human_attribute_name('creation_time') + ' : ' + l(object.creation_time, :format => :short)
        end), 
        (content_tag :li do
          object.human_attribute_name('creator_id') + ' : ' + object.creator_id if  object.creator_id
        end)].join.html_safe
      end
    end
  end
end
