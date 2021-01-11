require 'rails_helper'

RSpec.describe CreateTradeService do
  let(:avg_receiving) { '63' }
  let(:avg_sending) { '62' }
  let(:receiving) { ['charmander'] }
  let(:sending) { ['squirtle'] }

  context '#call' do
    it 'return true if received valid params' do
      adapter = instance_double(
        TradeAdapter,
        avg_receiving: avg_receiving,
        avg_sending: avg_sending,
        receiving: receiving,
        sending: sending
      )

      service = described_class.new(adapter)

      expect(service.call).to be_truthy
    end

    it 'return false if received invalid params' do
      avg_sending = nil

      adapter = instance_double(
        TradeAdapter,
        avg_receiving: avg_receiving,
        avg_sending: avg_sending,
        receiving: receiving,
        sending: sending
      )

      service = described_class.new(adapter)

      expect(service.call).to be_falsey
    end
  end

  context '#trade' do
    it 'return the trade object' do
      adapter = instance_double(
        TradeAdapter,
        avg_receiving: avg_receiving,
        avg_sending: avg_sending,
        receiving: receiving,
        sending: sending
      )

      service = described_class.new(adapter)
      service.call

      expect(service.trade.id).to eq(Exchange.last.id)
    end

    it 'return false if received invalid params' do
      avg_sending = nil

      adapter = instance_double(
        TradeAdapter,
        avg_receiving: avg_receiving,
        avg_sending: avg_sending,
        receiving: receiving,
        sending: sending
      )

      service = described_class.new(adapter)
      service.call

      expect(service.trade.errors.messages).to eq({:avg_sending=>["can't be blank"]})
    end
  end
end
