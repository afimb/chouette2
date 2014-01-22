class RuleParameterSet < ActiveRecord::Base
  belongs_to :referential

  validates_presence_of :referential
  validates_presence_of :name

  serialize :parameters, JSON

  attr_accessible :name, :referential_id

  def self.mode_attribute_prefixes
    %w( inter_stop_area_distance_min inter_stop_area_distance_max speed_max speed_min inter_stop_duration_variation_max)
  end
  def self.general_attributes
    %w( inter_stop_area_distance_min parent_stop_area_distance_max stop_areas_area inter_access_point_distance_min
      inter_connection_link_distance_max walk_default_speed_max
      walk_occasional_traveller_speed_max walk_frequent_traveller_speed_max walk_mobility_restricted_traveller_speed_max
      inter_access_link_distance_max inter_stop_duration_max facility_stop_area_distance_max)
  end
  def self.all_modes
    Chouette::TransportMode.all.map { |m| m.to_s}
  end

  def self.mode_attribute?( method_name )
    pattern = /(\w+)_mode_(\w+)/
    return false unless method_name.match( pattern)

    mode_attribute_prefixes.include?( $1) && self.class.all_modes.include?( $2)
  end
  def self.mode_of_mode_attribute( method_name )
    method_name.match( /(\w+)_mode_(\w+)/)
    $2
  end
  def self.attribute_of_mode_attribute( method_name )
    method_name.match( /(\w+)_mode_(\w+)/)
    $1
  end

  def self.mode_parameter(name)
    name = name.to_s
    attr_accessible name

    define_method(name) do
      attribute_name, mode = RuleParameterSet.attribute_of_mode_attribute( name), RuleParameterSet.mode_of_mode_attribute( name)
      self.parameters and self.parameters["mode_#{mode}"] and
        self.parameters["mode_#{mode}"][attribute_name]
    end

    define_method("#{name}=") do |prefix|
      attribute_name, mode = RuleParameterSet.attribute_of_mode_attribute( name), RuleParameterSet.mode_of_mode_attribute( name)
      ((self.parameters ||= {})["mode_#{mode}"] ||= {})[attribute_name] = prefix
    end
  end
  def self.parameter(name)
    name = name.to_s
    attr_accessible name

    define_method(name) do
        self.parameters and self.parameters[name]
    end

    define_method("#{name}=") do |prefix|
        (self.parameters ||= {})[name] = prefix
    end
  end

  def self.default_params(mode=nil)
    base = { :inter_stop_area_distance_min => 20,
      :parent_stop_area_distance_max => 300,
      :inter_access_point_distance_min => 20,
      :inter_connection_link_distance_max => 400,
      :walk_default_speed_max => 4,
      :walk_occasional_traveller_speed_max => 2,
      :walk_frequent_traveller_speed_max => 5,
      :walk_mobility_restricted_traveller_speed_max => 1,
      :inter_access_link_distance_max => 300,
      :inter_stop_duration_max => 40,
      :facility_stop_area_distance_max => 300
    }
    if mode && self.mode_default_params[ mode.to_sym]
      base.merge!( self.mode_default_params[ mode.to_sym])
    end
    base
  end
  def self.mode_default_params
    {
    :coach => {
      :inter_stop_area_distance_min_mode_coach => 500,
      :inter_stop_area_distance_max_mode_coach => 10000,
      :speed_max_mode_coach => 90,
      :speed_min_mode_coach => 40,
      :inter_stop_duration_variation_max_mode_coach => 20},
    :air => {
      :inter_stop_area_distance_min_mode_air => 200,
      :inter_stop_area_distance_max_mode_air => 10000,
      :speed_max_mode_air => 800,
      :speed_min_mode_air => 700,
      :inter_stop_duration_variation_max_mode_air => 60},
    :waterborne => {
      :inter_stop_area_distance_min_mode_waterborne => 200,
      :inter_stop_area_distance_max_mode_waterborne => 10000,
      :speed_max_mode_waterborne => 40,
      :speed_min_mode_waterborne => 5,
      :inter_stop_duration_variation_max_mode_waterborne => 60},
    :bus => {
      :inter_stop_area_distance_min_mode_bus => 100,
      :inter_stop_area_distance_max_mode_bus => 10000,
      :speed_max_mode_bus => 60,
      :speed_min_mode_bus => 10,
      :inter_stop_duration_variation_max_mode_bus => 15},
    :ferry => {
      :inter_stop_area_distance_min_mode_ferry => 200,
      :inter_stop_area_distance_max_mode_ferry => 10000,
      :speed_max_mode_ferry => 40,
      :speed_min_mode_ferry => 5,
      :inter_stop_duration_variation_max_mode_ferry => 60},
    :walk => {
      :inter_stop_area_distance_min_mode_walk => 1,
      :inter_stop_area_distance_max_mode_walk => 10000,
      :speed_max_mode_walk => 6,
      :speed_min_mode_walk => 1,
      :inter_stop_duration_variation_max_mode_walk => 10},
    :metro => {
      :inter_stop_area_distance_min_mode_metro => 300,
      :inter_stop_area_distance_max_mode_metro => 2000,
      :speed_max_mode_metro => 60,
      :speed_min_mode_metro => 30,
      :inter_stop_duration_variation_max_mode_metro => 30},
    :shuttle => {
      :inter_stop_area_distance_min_mode_shuttle => 500,
      :inter_stop_area_distance_max_mode_shuttle => 10000,
      :speed_max_mode_shuttle => 80,
      :speed_min_mode_shuttle => 20,
      :inter_stop_duration_variation_max_mode_shuttle => 10},
    :rapid_transit => {
      :inter_stop_area_distance_min_mode_rapid_transit => 2000,
      :inter_stop_area_distance_max_mode_rapid_transit => 500000,
      :speed_max_mode_rapid_transit => 300,
      :speed_min_mode_rapid_transit => 20,
      :inter_stop_duration_variation_max_mode_rapid_transit => 60},
    :taxi => {
      :inter_stop_area_distance_min_mode_taxi => 500,
      :inter_stop_area_distance_max_mode_taxi => 300000,
      :speed_max_mode_taxi => 130,
      :speed_min_mode_taxi => 20,
      :inter_stop_duration_variation_max_mode_taxi => 60},
    :local_train => {
      :inter_stop_area_distance_min_mode_local_train => 2000,
      :inter_stop_area_distance_max_mode_local_train => 500000,
      :speed_max_mode_local_train => 300,
      :speed_min_mode_local_train => 20,
      :inter_stop_duration_variation_max_mode_local_train => 60},
    :train => {
      :inter_stop_area_distance_min_mode_train => 2000,
      :inter_stop_area_distance_max_mode_train => 500000,
      :speed_max_mode_train => 300,
      :speed_min_mode_train => 20,
      :inter_stop_duration_variation_max_mode_train => 60},
    :long_distance_train => {
      :inter_stop_area_distance_min_mode_long_distance_train => 2000,
      :inter_stop_area_distance_max_mode_long_distance_train => 500000,
      :speed_max_mode_long_distance_train => 300,
      :speed_min_mode_long_distance_train => 20,
      :inter_stop_duration_variation_max_mode_long_distance_train => 60},
    :tramway => {
      :inter_stop_area_distance_min_mode_tramway => 300,
      :inter_stop_area_distance_max_mode_tramway => 2000,
      :speed_max_mode_tramway => 50,
      :speed_min_mode_tramway => 20,
      :inter_stop_duration_variation_max_mode_tramway => 30},
    :trolleybus => {
      :inter_stop_area_distance_min_mode_trolleybus => 300,
      :inter_stop_area_distance_max_mode_trolleybus => 2000,
      :speed_max_mode_trolleybus => 50,
      :speed_min_mode_trolleybus => 20,
      :inter_stop_duration_variation_max_mode_trolleybus => 30},
    :private_vehicle => {
      :inter_stop_area_distance_min_mode_private_vehicle => 500,
      :inter_stop_area_distance_max_mode_private_vehicle => 300000,
      :speed_max_mode_private_vehicle => 130,
      :speed_min_mode_private_vehicle => 20,
      :inter_stop_duration_variation_max_mode_private_vehicle => 60},
    :bicycle => {
      :inter_stop_area_distance_min_mode_bicycle => 300,
      :inter_stop_area_distance_max_mode_bicycle => 30000,
      :speed_max_mode_bicycle => 40,
      :speed_min_mode_bicycle => 10,
      :inter_stop_duration_variation_max_mode_bicycle => 10},
    :other => {
      :inter_stop_area_distance_min_mode_other => 300,
      :inter_stop_area_distance_max_mode_other => 30000,
      :speed_max_mode_other => 40,
      :speed_min_mode_other => 10,
      :inter_stop_duration_variation_max_mode_other => 10},
    }
    # :waterborne, :bus, :ferry, :walk, :metro, :shuttle, :rapidtransit, :taxi, :localtrain, :train, :longdistancetrain, :tramway, :trolleybus, :privatevehicle, :bicycle, :other
  end
  def self.default( referential)
    self.default_for_all_modes( referential).tap do |rps|
      rps.name = ""
    end
  end
  def self.default_for_all_modes( referential)
    mode_attributes = mode_default_params.values.inject(self.default_params){|memo, obj| memo.merge! obj}
    self.new(
      { :referential_id => referential.id,
        :stop_areas_area => referential.envelope.to_polygon.points.map(&:to_coordinates).to_json,
        :name => "valeurs par defaut"
      }.merge( mode_attributes))
  end

  all_modes.each do |mode|
    mode_attribute_prefixes.each do |prefix|
      mode_parameter "#{prefix}_mode_#{mode}".to_sym
    end
  end

  general_attributes.each do |attribute|
    parameter attribute.to_sym
    unless attribute == "stop_areas_area"
      validates attribute.to_sym, :numericality => true, :allow_nil => true, :allow_blank => true
    end
  end

end
