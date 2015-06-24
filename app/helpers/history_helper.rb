module HistoryHelper

  def creation_tag(object)
    field_set_tag t("layouts.history_tag.title"), :class => "history_tag" do
      content_tag :ul do
        [(content_tag :li do
          if object.has_attribute?(:creation_time)
            object.human_attribute_name('creation_time') + ' : ' + l(object.creation_time, :format => :short)
          else
            object.class.human_attribute_name('created_at') + ' : ' + l(object.created_at, :format => :short)
          end
        end),
        (content_tag :li do
           if object.has_attribute?(:creator_id)
             object.human_attribute_name('creator_id') + ' : ' + object.creator_id if object.creator_id
           end
        end),
        (content_tag :li do
           if object.has_attribute?(:objectid)
             object.human_attribute_name('objectid') + ' : ' + object.objectid if object.objectid
           end
        end),
        (content_tag :li do
           if object.has_attribute?(:object_version)
             object.human_attribute_name('object_version') + ' : ' + object.object_version.to_s if object.object_version
           end
        end)].join.html_safe
      end
    end
  end

  def history_tag(object)
    field_set_tag t("layouts.history_tag.title"), class: "history_tag" do
      content_tag :ul do
        [:created_at, :updated_at, :user_name, :name, :organisation_name,
         :referential_name, :no_save, :clean_repository].each do |field|
          concat history_tag_li(object, field)
        end
      end
    end
  end

  protected

  def history_tag_li(object, field)
    if object.respond_to?(field)
      key = t("layouts.history_tag.#{field}")
      value = object.public_send(field)
      value = l(value, format: :short) if value.is_a?(Time)
      content_tag(:li, "#{key} : #{value}")
    end
  end
end
