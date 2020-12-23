require 'rails_helper'

RSpec.describe FetchPokemonsService do
  let(:offering) {
    [
      "Farfetch'd",
      "Pikachu",
      "Charmander",
      "Wooloo",
      "Nidoking",
      "Venomoth"
    ]
  }
  let(:receiving) {
    [
      "Pikachu",
      "Charmander",
      "Sandaconda",
      "Zubat",
      "Alakazam",
      "Drowzee"
    ]
  }
  it 'return updated list of pokemons' do
    service = described_class.new(offering, receiving)
    expect(service.call).to eq({
      offering: [
        {base_experience: 132, pokemon:"farfetchd"},
        {base_experience: 112, pokemon: "pikachu"},
        {base_experience: 62, pokemon: "charmander"},
        {base_experience: 122, pokemon: "wooloo"},
        {base_experience: 227, pokemon: "nidoking"},
        {base_experience: 158, pokemon: "venomoth"}
      ],
      receiving: [
        {base_experience: 112, pokemon: "pikachu"},
        {base_experience: 62, pokemon: "charmander"},
        {base_experience: 179, pokemon: "sandaconda"},
        {base_experience: 49, pokemon: "zubat"},
        {base_experience: 225, pokemon: "alakazam"},
        {base_experience: 66, pokemon: "drowzee"}
      ]
    })
  end
end
