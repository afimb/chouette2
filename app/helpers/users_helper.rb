module UsersHelper

  def user_gravatar_image_tag(user, size = 64)
    gravatar_image_tag user.email, :alt => user.name, :class => "preview", :gravatar => { :default => user_default_avatar , :size => size }
  end

  def user_default_avatar
    return "#{root_url}#{image_path('icons/user.png')}" if Rails.application.config.relative_url_root.blank?

    relative_url_root = Rails.application.config.relative_url_root.gsub( /\//, '')
    "#{root_url}#{image_path('icons/user.png')}".
      sub( Regexp.new("/#{relative_url_root}/#{relative_url_root}/"), "/#{relative_url_root}/").
      sub( Regexp.new("/#{relative_url_root}//#{relative_url_root}/"), "/#{relative_url_root}/")
  end

end
