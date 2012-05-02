module Sluggy
  SLUG_REGEX = %r{^[a-z0-9\-\_]+$}i

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def slug_for(base, options={})
      options.reverse_merge!(:column => :permalink, :base => base, :scope => nil)
      validates options[:column], :presence => true, :format => { :with => Sluggy::SLUG_REGEX }, :length => { :within => 1..100 }, :uniqueness => (options[:scope] ? {:scope => options[:scope]} : true)
      before_validation :generate_slug
      class_eval %{ def self.sluggy_options; #{options}; end }
      include Sluggy::InstanceMethods
    end
  end

  module InstanceMethods
    private
    def slug_column; self.class.sluggy_options[:column]; end
    def slug_scope;  self.class.sluggy_options[:scope]; end
    def slug_base;   self.class.sluggy_options[:base]; end

    def generate_slug
      if send(slug_column).blank?
        slug = send(slug_base).to_s.downcase.gsub(/[^a-z0-9\s\-\_]/, '').strip.gsub(/\s+/, '-')

        exists = self.class.where("#{slug_column} = ? OR #{slug_column} LIKE ?", slug, "#{slug}--%")
        exists = exists.where('id != ?', id) unless new_record?
        exists = exists.where("#{slug_scope} = ?", send(slug_scope)) if slug_scope
        exists = exists.order("LENGTH(#{slug_column}) DESC, #{slug_column} DESC")

        if conflict = exists.first
          last_number =  conflict.send(slug_column).gsub(/^#{Regexp.quote(slug)}--/, '').to_i
          slug << "--#{last_number+1}"
        end

        send("#{slug_column}=", slug)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Sluggy)
