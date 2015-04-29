if RUBY_PLATFORM == 'java' # Allows the application to work with other Rubies if not JRuby
  require 'java'
  java_import 'java.lang.ClassNotFoundException'

  begin
    security_class = java.lang.Class.for_name('javax.crypto.JceSecurity')
    restricted_field = security_class.get_declared_field('isRestricted')
    restricted_field.accessible = true
    restricted_field.set nil, false
  rescue ClassNotFoundException => e
    # Handle Mac Java, etc not having this configuration setting
    $stderr.print "Java told me: #{e}n"
  end
end
