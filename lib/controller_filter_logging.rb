require 'abstract_controller'

module AbstractController::Callbacks::ClassMethods
  def before_filter_with_logging(*args, &block)
    handle_filter(:before_filter, *args, &block)
  end
  alias_method_chain :before_filter, :logging

  def skip_before_filter_with_logging(filter_name, *args)
    skip_before_filter_without_logging(filter_name_to_logging_filter_name(filter_name).to_sym, *args)
  end
  alias_method_chain :skip_before_filter, :logging

  def prepend_before_filter_with_logging(*args, &block)
    handle_filter(:prepend_before_filter, *args, &block)
  end
  alias_method_chain :prepend_before_filter, :logging

  private
  def handle_filter(type, *args, &block)
    method = "#{type}_without_logging"
    if block_given?
      Rails.logger.debug("Can't log filters with blocks: #{caller[0..3].join("\n")}")
      send(method, *args, &block)
    else
      filter_name = args.shift
      send(method, create_logging_filter(filter_name), *args)
    end
  end

  def create_logging_filter(filter_name)
    name = filter_name_to_logging_filter_name(filter_name)
    define_method(name) do
      Rails.logger.debug("Entering before_filter: #{filter_name}")
      start_time = Time.now
      send(filter_name).tap do |result|
        stop_time = Time.now
        begin
          Rails.logger.debug(" result (#{sprintf("%.5f", stop_time - start_time)}): #{result.inspect}")
        rescue
          Rails.logger.debug(" error outputting result: #{$!.class.name}/#{$!.message}")
        end
      end
    end
    name.to_sym
  end

  protected
    def filter_name_to_logging_filter_name(filter_name)
      "#{filter_name.to_s.gsub(%r{[?!]}, '')}_with_logging"
    end

end
