require 'rails_helper'

RSpec.describe TradeContract do
  let(:params) do
    {
      sending: [{ name: 'Pikachu'}],
      receiving: [{ name: 'Charmander'}]
    }
  end

  it 'return a hash with validated params' do
    contract = described_class.new

    expect(contract.call(params).to_h).to match(
      {
        sending: [{ name: "Pikachu"}],
        receiving: [{ name: "Charmander"}]
      }
    )
  end

  it 'return an error message caused by a invalid param' do
    params[:sending].push(
      { name: "Farfetch'd" },
      { name: "Sandaconda" },
      { name: "Charmander" },
      { name: "Wooloo" },
      { name: "Nidoking" },
      { name: "Venomoth" }
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
      { sending: ["size cannot be less than 1"] }
    )
  end

  context 'when a pokemon name have special characters' do
    it 'return the name without the special character' do
      params[:sending] << { name: "Farfetch'd" }
      contract = described_class.new

      expect(contract.call(params).to_h).to eq(
        {
          sending: [
            { name: "Pikachu"},
            { name: "Farfetch'd"}
          ],
          receiving: [{ name: "Charmander"}]
        }
      )
    end
  end
end
