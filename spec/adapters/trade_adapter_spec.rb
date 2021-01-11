require 'rails_helper'

RSpec.describe TradeAdapter do
  let(:params) do
    {
      sending: ['Pikachu'],
      receiving: ['Charmander']
    }
  end

  context '#receiving' do
    it 'return an array without nil params' do
      params[:receiving] << ''

      adapter = described_class.new(params)
      expect(adapter.receiving).to eq(['charmander'])
    end

    it 'return an array without special characters' do
      params[:receiving] << "Farfetch'd"

      adapter = described_class.new(params)
      expect(adapter.receiving).to eq(['charmander', 'farfetchd'])
    end
  end

  context '#sending' do
    it 'return an array without nil params' do
      params[:sending] << ''

      adapter = described_class.new(params)
      expect(adapter.sending).to eq(['pikachu'])
    end

    it 'return an array without special characters' do
      params[:sending] << "Farfetch'd"

      adapter = described_class.new(params)
      expect(adapter.sending).to eq(['pikachu', 'farfetchd'])
    end
  end

  context '#avg_receiving' do
    let(:params) do
      {
        sending: ['Squirtle'],
        receiving: ['Charmander'],
        avg_receiving: '63',
        avg_sending: '62'
      }
    end

    it 'return the value received on params' do
      adapter = described_class.new(params)

      expect(adapter.avg_receiving).to eq('63')
    end

    it 'return a empty string if the param dont received' do
      params.delete(:avg_receiving)

      adapter = described_class.new(params)
      expect(adapter.avg_receiving.zero?).to be_truthy
    end
  end

  context '#avg_sending' do
    let(:params) do
      {
        sending: ['Squirtle'],
        receiving: ['Charmander'],
        avg_receiving: '63',
        avg_sending: '62'
      }
    end

    it 'return the value received on params' do
      adapter = described_class.new(params)

      expect(adapter.avg_sending).to eq('62')
    end

    it 'return a empty string if the param dont received' do
      params.delete(:avg_sending)

      adapter = described_class.new(params)
      expect(adapter.avg_sending.zero?).to be_truthy
    end
  end
end
