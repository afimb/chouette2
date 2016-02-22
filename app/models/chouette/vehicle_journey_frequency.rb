module Chouette
  class VehicleJourneyFrequency < VehicleJourney

    after_initialize :fill_journey_category

    default_scope { where(journey_category: journey_categories[:frequency]) }

    has_many :journey_frequencies, dependent: :destroy, foreign_key: 'vehicle_journey_id'
    accepts_nested_attributes_for :journey_frequencies, allow_destroy: true

    validate :require_at_least_one_frequency

    def self.matrix(vehicle_journeys)
      hash = {}
      vehicle_journeys.each do |vj|
        vj.journey_frequencies.each do |jf|
          next if jf.scheduled_headway_interval.hour == 0 && jf.scheduled_headway_interval.min == 0
          interval = jf.scheduled_headway_interval.hour.hours + jf.scheduled_headway_interval.min.minutes
          first_departure_time = jf.first_departure_time
          while first_departure_time <= jf.last_departure_time
            hash[first_departure_time] = vj
            first_departure_time += interval
          end
        end
      end
      hash.sort.to_h
    end

    def self.matrix_interval(matrix)
      hash = prepare_matrix(matrix)
      matrix.each do |departure_time, vj|
        @base_departure_time = departure_time
        vj.vehicle_journey_at_stops.each_cons(2) { |vjas, vjas_next|
          vjas_dup = vjas.dup
          vjas_dup.departure_time = @base_departure_time
          hash[vjas.stop_point.stop_area.name][departure_time.to_i] = vjas_dup
          @base_departure_time = vjas_dup.departure_time + (vjas_next.departure_time - vjas.departure_time)
          @last_vjas_next = vjas_next.dup
        }
        # Add last stop_point
        @last_vjas_next.departure_time = @base_departure_time
        hash[@last_vjas_next.stop_point.stop_area.name][departure_time.to_i] = @last_vjas_next
      end
      hash
    end

    private

    def self.prepare_matrix(matrix)
      matrix.map{ |departure_time, vj|
        Hash[
          vj.vehicle_journey_at_stops.map{ |sp|
            [
              sp.stop_point.stop_area.name, Hash[matrix.map{ |departure_time2, vj2| [departure_time2.to_i, nil] }]
            ]
          }
        ]
      }.inject(&:merge)
    end

    def fill_journey_category
      self.journey_category = :frequency
    end

    def require_at_least_one_frequency
      errors.add(:base, I18n.t('vehicle_journey_frequency.require_at_least_one_frequency')) unless journey_frequencies.size > 0
    end
  end
end
