attributes :objectid => :object_id
[ :object_version, :creation_time, :creator_id].each do |attr|
  attributes attr, :unless => lambda { |m| m.send( attr).nil?}
end

