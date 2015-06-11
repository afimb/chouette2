# -*- coding: utf-8 -*-
module NinoxeExtension::Hub::ObjectidRestrictions
    extend ActiveSupport::Concern

    included do
      # HUB 1
      validate :third_part_objectid_uniqueness
    end

    def validate_specific_objectid( size_max )
      errors.add( :objectid, I18n.t('hub.invalid')) if ( %r{\A\w+:\w+:\w+\z}).match( self.objectid).nil?

      if third_part_objectid.nil? || ( !third_part_objectid.include?( "_pending_" ) && third_part_objectid.size > size_max)
        errors.add( :objectid, I18n.t('hub.invalid'))
      end
    end
    def third_part_objectid
      return nil if ( %r{\A\w+:\w+:\w+\z}).match( self.objectid).nil?
      self.objectid.match(/:(\w+)\z/)[1]
    end
    def third_part_objectid_uniqueness
      return unless hub_restricted?

      return true unless third_part_objectid
      likes = Chouette::Line.where( "objectid LIKE ?", "%:#{self.third_part_objectid}" )
      likes.size.zero? || ( likes.size==1 && likes.first.id==self.id)
    end
end

