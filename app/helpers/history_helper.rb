module HistoryHelper

  def creation_tag(object)
    field_set_tag t("layouts.creation_tag.title") do
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
             object.human_attribute_name('creator_id') + ' : ' + object.creator_id if  object.creator_id
           end
        end)].join.html_safe
      end
    end
  end
  
  def history_tag(object)
    field_set_tag t("layouts.history_tag.title") do
      content_tag :ul do
        [(content_tag :li do
          if object.has_attribute?(:created_at)    
            t('layouts.history_tag.created_at') + ' : ' + l(object.created_at, :format => :short)
          end
        end),
        (content_tag :li do
          if object.has_attribute?(:updated_at)    
            t('layouts.history_tag.updated_at') + ' : ' + l(object.updated_at, :format => :short)
          end
        end),  
        (content_tag :li do
           if object.has_attribute?(:user_name)
             t('layouts.history_tag.user_name') + ' : ' + object.user_name if  object.user_name
           end
        end)].join.html_safe
      end
    end
  end
end
