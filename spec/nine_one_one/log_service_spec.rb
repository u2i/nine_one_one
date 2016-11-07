require 'spec_helper'

describe NineOneOne::LogService do
  describe '#trigger_event' do
    let(:logger) { double('logger') }

    subject { NineOneOne::LogService.new(logger) }

    it 'calls logger#error' do
      expect(logger).to receive(:error).with(String)
      subject.trigger_event('key', 'desc', a: 'b', c: 'd')
    end
  end
end
