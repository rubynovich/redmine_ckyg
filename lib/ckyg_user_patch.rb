module CkygPlugin
  module UserPatch
    def self.included(base)
      # base.extend(ClassMethods)

      # base.send(:include, InstanceMethods)

      base.class_eval do

        const_set(:USER_FORMATS, const_get(:USER_FORMATS).merge({:lastname_firstname_middlename => {:string => '#{lastname} #{firstname} #{middlename}', :order => %w(lastname firstname id), :setting_order => 4}}))

      end
    end

    # module ClassMethods
    # end

    # module InstanceMethods
    # end

  end
end


