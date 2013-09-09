# -*- coding: utf-8 -*-
require 'chinese_pinyin'
module MongoidCnPermalink

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    class << base
      attr_accessor :permalink_key
    end
  end

  module ClassMethods

    def has_permalink(attr)
      field :permalink, type: String
      self.permalink_key = attr
      validates :permalink, uniqueness: true
      before_validation :create_permalink
    end

    def find_by_permalink(slug)
      self.any_of({:permalink => slug}, {:_id => slug}).first
    end

  end

  module InstanceMethods

    private
    def create_permalink
      return unless self.send("#{self.class.permalink_key}_changed?")
      self.permalink = Pinyin.t(read_attribute(self.class.permalink_key))
      remove_special_chars
      random_permalink if permalink.blank?
      create_unique_permalink
    end

    def remove_special_chars
      permalink.gsub!(/[àáâãäå]/i,'a')
      permalink.gsub!(/[èéêë]/i,'e')
      permalink.gsub!(/[íìîï]/i,'i')
      permalink.gsub!(/[óòôöõ]/i,'o')
      permalink.gsub!(/[úùûü]/i,'u')
      permalink.gsub!(/æ/i,'ae')
      permalink.gsub!(/ç/i, 'c')
      permalink.gsub!(/ñ/i, 'n')
      permalink.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      permalink.gsub!(/[^\w_ \-]+/i, '') # Remove unwanted chars.
      permalink.gsub!(/[ \-]+/i, '-') # No more than one of the separator in a row.
      permalink.gsub!(/^\-|\-$/i, '') # Remove leading/trailing separator.
      permalink.downcase!
    end

    def create_unique_permalink
      permalink_old = permalink
      suffix = 1
      while exist_permalink?(permalink_old) do
        permalink_old = permalink + suffix.to_s
        suffix = suffix +1
      end
      self.permalink = permalink_old
    end

    def random_permalink
      self.permalink = rand(9999999999).to_s
    end

    def exist_permalink?(current_permalink)
      self.class.find_by_permalink(current_permalink) == self || !self.class.superclass.find_by_permalink(current_permalink).nil?
    end
  end

end
