require 'rails'

RSpec.configure do |c|
  c.mock_with :mocha

  c.before do
    @logs = StringIO.new
    Rails.logger = (@logger = Logger.new(@logs))
  end
end

