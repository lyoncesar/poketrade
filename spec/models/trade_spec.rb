require 'rails_helper'

RSpec.describe Exchange, type: :model do
  context 'save a trade' do
    let(:params) do
      {
        avg_receiving: '63',
        avg_sending: '62',
        receiving: ['charmander'],
        sending: ['squirtle']
      }
    end

    it 'persist without errors' do
      trade = described_class.new(params)

      expect{trade.save}.to change{Exchange.count}.by(1)
    end

    it "returns error if any parameter is missing" do
      params.delete(:sending)

      trade = described_class.new(params)
      trade.save

      expect(trade.errors.messages).to eq({ :sending=>["can't be blank"] })
    end
  end
end
