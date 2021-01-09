require 'rails_helper'

RSpec.describe TradeContract do
  let(:params) do
    {
      sending: ["Pikachu"],
      receiving: ["Charmander"]
    }
  end

  it 'return a hash with validated params' do
    contract = described_class.new

    expect(contract.call(params).to_h).to match(
      {
        sending: ["Pikachu"],
        receiving: ["Charmander"]
      }
    )
  end

  it 'return an error message caused by a invalid param' do
    params[:sending].push(
      "Farfetch'd",
      "Sandaconda",
      "Charmander",
      "Wooloo",
      "Nidoking",
      "Venomoth"
    )

    contract = described_class.new

    expect(contract.call(params).errors.to_h).to eq(
      {
        sending: ["The trade is limited of 6 Pokemons over each side"]
      }
    )
  end

  it 'return an error message caused by a empty param' do
    params[:sending].pop
    contract = described_class.new

    expect(contract.call(params).errors.to_h).to eq(
      { sending: ["must be filled"] }
    )
  end

  context 'when a pokemon name have special characters' do
    it 'return the name without the special character' do
      params[:sending] << "Farfetch'd"
      contract = described_class.new

      expect(contract.call(params).to_h).to eq(
        {
          sending: [
            "Pikachu",
            "Farfetch'd"
          ],
          receiving: ["Charmander"]
        }
      )
    end
  end
end
