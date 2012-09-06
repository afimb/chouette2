module UsersHelper

  def user_gravatar_image_tag(user)
    gravatar_image_tag user.email, :alt => user.name, :class => "preview", :gravatar => { :default => user_default_avatar, :size => 64 }
  end

  def user_default_avatar
    "#{root_url}#{image_path('icons/user.png')}"
  end

end
