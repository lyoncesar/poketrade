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
end
