module AbstractController::Callbacks::ClassMethods
  def before_filter_with_logging(filter_name, *args)
    create_logging_filter(filter_name)
    before_filter_without_logging "#{filter_name}_with_logging".to_sym, *args
  end
  alias_method_chain :before_filter, :logging

  def skip_before_filter_with_logging(filter_name, *args)
    skip_before_filter_without_logging("#{filter_name}_with_logging".to_sym, *args)
  end
  alias_method_chain :skip_before_filter, :logging

  def prepend_before_filter_with_logging(filter_name, *args)
    create_logging_filter(filter_name)
    prepend_before_filter_without_logging("#{filter_name}_with_logging".to_sym, *args)
  end
  alias_method_chain :prepend_before_filter, :logging

  def create_logging_filter(filter_name)
    define_method("#{filter_name}_with_logging") do
      Rails.logger.debug("Entering before_filter: #{filter_name}")
      send(filter_name).tap do |result|
        Rails.logger.debug(" result: #{result}")
      end
    end
  end
end
