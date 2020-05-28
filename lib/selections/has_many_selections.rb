module Selections
  module HasManySelections

    # Helper for has_many and accepts all the standard rails options
    #
    # Example
    #   class Thing < ActiveRecord::Base
    #     has_many_selections :priority
    #
    # by default adds - class_name: "Selection"
    #
    # This macro also adds a number of methods onto the class if there is a selection
    # named as the class underscore name (eg: "thing_priority"), then methods are created
    # for all of the selection values under that parent. For example:
    #
    #   thing = Thing.find(x)
    #   thing.priority = Selection.thing_priority_high
    #   thing.priority_high? #=> true
    #   thing.priority_low?  #=> false
    #
    # thing.priority_high? is equivalent to thing.priority == Selection.thing_priority_high
    # except that the id of the selection is cached at the time the class is loaded.
    #
    # Note that this is only appropriate to use for system selection values that are known
    # at development time, and not to values that the users can edit in the live system.
    def has_many_selections(target, options = {})
      target_id = "#{target.to_s.singularize}_ids".to_sym

      if ActiveRecord::VERSION::MAJOR > 4
        has_many target, options.reject { |k, v| [:system_code].include?(k) }.merge(class_name: 'Selection', primary_key: target_id, foreign_key: :id)
      else
        has_many target, options.reject { |k, v| [:system_code].include?(k) }.merge(class_name: self.name, primary_key: target_id, foreign_key: :id)
      end
    end

    ActiveSupport.on_load :active_record do
      extend Selections::HasManySelections
    end
  end
end
