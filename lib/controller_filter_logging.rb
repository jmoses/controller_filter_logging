module AbstractController::Callbacks::ClassMethods
  def before_filter_with_logging(*args, &block)
    if block_given?
      Rails.logger.debug("Can't log filters with blocks: #{caller[0..3].join("\n")}")
      before_filter_without_logging *args, &block
    else
      filter_name = args.shift
      before_filter_without_logging create_logging_filter(filter_name), *args
    end
  end
  alias_method_chain :before_filter, :logging

  def skip_before_filter_with_logging(filter_name, *args)
    skip_before_filter_without_logging("#{filter_name}_with_logging".to_sym, *args)
  end
  alias_method_chain :skip_before_filter, :logging

  def prepend_before_filter_with_logging(filter_name, *args, &block)
    if block_given?
      Rails.logger.debug("Can't log filters with blocks: #{caller[0..3].join("\n")}")
      prepend_before_filter_without_logging filter_name, *args, &block
    else
      create_logging_filter(filter_name)
      prepend_before_filter_without_logging("#{filter_name}_with_logging".to_sym, *args)
    end
  end
  alias_method_chain :prepend_before_filter, :logging

  def create_logging_filter(filter_name)
    name = "#{filter_name.to_s.gsub(%r{[?!]}, '')}_with_logging"
    define_method(name) do
      Rails.logger.debug("Entering before_filter: #{filter_name}")
      send(filter_name).tap do |result|
        begin
          Rails.logger.debug(" result: #{result.inspect}")
        rescue
          Rails.logger.debug(" error outputting result: #{$!.class.name}/#{$!.message}")
        end
      end
    end
    name.to_sym
  end
end
