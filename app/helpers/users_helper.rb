module UsersHelper

  def user_gravatar_image_tag(user, size = 64)
      image_tag user_image(user), :alt => "", :class => "preview", :width => size, :height => size
  end

#  def user_default_avatar
#    return "#{authenticated_root_url}#{image_path('icons/user.png')}" if Rails.application.config.relative_url_root.blank?
#   relative_url_root = Rails.application.config.relative_url_root.gsub( /\//, '')
#    "#{authenticated_root_url}#{image_path('icons/user.png')}".
#      sub( Regexp.new("/#{relative_url_root}/#{relative_url_root}/"), "/#{relative_url_root}/").
#      sub( Regexp.new("/#{relative_url_root}//#{relative_url_root}/"), "/#{relative_url_root}/")
#  end

  def gravatar_hash(user)
    Digest::MD5.hexdigest( user.email)
  end
  def gravatar_url( user)
    "http://www.gravatar.com/avatar/#{gravatar_hash(user)}?d=404"
  end
  def user_image(user)
    begin
      gravatar_resource = RestClient.get( gravatar_url( user)){|response, request, result| response }
    rescue
      # Happens if network is not available
      return 'icons/user.png'
    end
    if gravatar_resource.code == 404
      # Happens if user has not registered to gravatar
      'icons/user.png'
    else
      gravatar_url( user)
    end
  end

end
