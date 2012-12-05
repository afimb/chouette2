module Api
  module V1
    class ApiKey
      def initialize(token)
        @organisation_id, @referential_id = token.split('-')
      end
      def self.create( organisation, referential)
        ApiKey.new( "#{organisation.id}-#{referential.id}")
      end
      def token
        "#{@organisation_id}-#{@referential_id}"
      end
      def exists?
        organisation && referential
      end
      def referential_slug
        referential.slug
      end
      def referential
        @referential ||= organisation.referentials.find_by_id @referential_id
      end 
      def eql?(other)
        other.token == self.token
      end
    private
      def organisation
        @organisation ||= Organisation.find_by_id @organisation_id
      end 
    end
  end
end

