require 'spec_helper'

describe NineOneOne::LogService do
  let(:logger) { double('logger') }

  subject { NineOneOne::LogService.new(logger) }

  describe '#trigger_event' do
    it 'calls logger#error' do
      expect(logger).to receive(:error).with(String)
      subject.trigger_event('key', 'desc', a: 'b', c: 'd')
    end
  end

  describe '#notify' do
    it 'calls logger#info' do
      expect(logger).to receive(:info).with(String)
      subject.notify('message')
    end
  end
end
