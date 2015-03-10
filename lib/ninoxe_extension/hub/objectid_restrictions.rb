# -*- coding: utf-8 -*-
module NinoxeExtension::Hub::ObjectidRestrictions
    extend ActiveSupport::Concern

    included do
      # HUB 1
      validate :third_part_objectid_uniqueness

      def third_part_objectid
        self.objectid.match(/:(\w+)\z/)[1]
      end
      def third_part_objectid_uniqueness
        return unless hub_restricted?

        return true unless third_part_objectid
        likes = Chouette::Line.where( "objectid LIKE ?", "%:#{self.third_part_objectid}" )
        likes.size.zero? || ( likes.size==1 && likes.first.id==self.id)
      end

    end
end

