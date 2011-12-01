require 'spec_helper'
require 'action_controller'

require 'controller_filter_logging'

describe 'controller_filter_logging' do
  describe '#before_filter_with_logging' do
    context 'with block' do
      it "should warn and pass through to the block" do
        Rails.logger.expects(:debug).once

        controller = Class.new(ActionController::Base) do
          attr_reader :called

          before_filter do
            @called = true
          end
        end.new

        controller.run_callbacks(:process_action)
        controller.called.should be_true
      end

      it "should run the block and log the results" do
        result = 12345

        Rails.logger.expects(:debug).with("Entering before_filter: test")
        Rails.logger.expects(:debug).with(" result (0.00001): #{result}")

        controller = Class.new(ActionController::Base) do
          attr_reader :called

          before_filter :test
          
          private
          def test
            @called = 12345
          end
        end.new

        controller.run_callbacks(:process_action)
        controller.called.should == result
        controller.methods.should include(:test_with_logging)
      end
    end
  end

  describe "#skip_before_filter_with_logging" do
    it "should skip a filter with a ! in it" do
      controller = Class.new(ActionController::Base) do
        attr_accessor :called
        def test_filter!
          @called = true
        end

        before_filter :test_filter!

      end.new

      controller.run_callbacks(:process_action)
      controller.called.should == true

      controller.called = nil
      controller.class_eval { skip_before_filter :test_filter! }

      controller.run_callbacks(:process_action)
      controller.called.should == nil
    end
  end
end

