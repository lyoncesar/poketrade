require 'rails_helper'

RSpec.describe FetchPokemonsService do
  let(:pokemons) do
    {
      sending: [
        "Farfetch'd",
        "Pikachu",
        "Charmander",
        "Wooloo",
        "Nidoking",
        "Venomoth"
      ],
      receiving: [
        "Pikachu",
        "Charmander",
        "Sandaconda",
        "Zubat",
        "Alakazam",
        "Drowzee"
      ]
    }
  end

  context '#updated_send' do
    it 'return the updated list of sended pokemons' do
      service = described_class.new(pokemons)
      expect(service.updated_send).to eq(
        [
          {base_experience: 132, pokemon:"farfetchd"},
          {base_experience: 112, pokemon: "pikachu"},
          {base_experience: 62, pokemon: "charmander"},
          {base_experience: 122, pokemon: "wooloo"},
          {base_experience: 227, pokemon: "nidoking"},
          {base_experience: 158, pokemon: "venomoth"}
        ]
      )
    end
  end

  context '#updated_receive' do
    it 'return the updated list of received pokemons' do
      service = described_class.new(pokemons)

      expect(service.updated_receive).to eq(
        [
          {base_experience: 112, pokemon: "pikachu"},
          {base_experience: 62, pokemon: "charmander"},
          {base_experience: 179, pokemon: "sandaconda"},
          {base_experience: 49, pokemon: "zubat"},
          {base_experience: 225, pokemon: "alakazam"},
          {base_experience: 66, pokemon: "drowzee"}
        ]
      )
    end
  end

  context '#unknown_pokemons' do
    it 'return the updated list of received pokemons' do
      service = described_class.new(pokemons)

      expect(service.unknown_pokemons).to eq([])
    end

    context 'when dont find a pokemon' do
      let(:pokemons) do
        {
          sending: [
            "Unknown",
            "Pikachu"
          ],
          receiving: [
            "Charmander",
            "Unknown Pokemon"
          ]
        }
      end

      it 'return his name on unknown attribute' do
        service = described_class.new(pokemons)

        expect(service.updated_receive).to eq( [{ base_experience: 62, pokemon: "charmander" }] )
        expect(service.updated_send).to eq( [{ base_experience: 112, pokemon: "pikachu" }] )
        expect(service.unknown_pokemons).to eq( ["Unknown Pokemon", "Unknown"] )
      end
    end
  end
end
