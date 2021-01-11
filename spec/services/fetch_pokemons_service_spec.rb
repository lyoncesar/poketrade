require 'rails_helper'

RSpec.describe FetchPokemonsService do
  let(:sending) do
      [
        "farfetchd",
        "pikachu",
        "charmander",
        "wooloo",
        "nidoking",
        "venomoth"
      ]
  end
  let(:receiving) do
    [
      "pikachu",
      "charmander",
      "sandaconda",
      "zubat",
      "alakazam",
      "drowzee"
    ]
  end

  let(:adapter) { instance_double(TradeAdapter) }

  before do
    expect(adapter).to receive(:receiving).and_return(receiving)
    expect(adapter).to receive(:sending).and_return(sending)
  end

  context '#updated_send' do
    it 'return the updated list of sended pokemons' do
      service = described_class.new(adapter)

      VCR.use_cassette('fetch_send_pokemons') do
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
  end

  context '#updated_receive' do
    it 'return the updated list of received pokemons' do
      service = described_class.new(adapter)

      VCR.use_cassette('fetch_receive_pokemons') do
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
  end

  context '#unknown_pokemons' do
    it 'return the updated list of received pokemons' do
      service = described_class.new(adapter)

      VCR.use_cassette('fetch_unknown_pokemons') do
        expect(service.unknown_pokemons).to eq([])
      end
    end

    context 'when dont find a pokemon' do
      let(:sending) do
        [
          "unknown",
          "pikachu"
        ]
      end
      
      let(:receiving) do
        [
          "charmander",
          "unknown-pokemon"
        ]
      end

      it 'return his name on unknown attribute' do
        service = described_class.new(adapter)

        VCR.use_cassette('fetch_pokemons') do
          expect(service.updated_receive).to eq( [{ base_experience: 62, pokemon: "charmander" }] )
          expect(service.updated_send).to eq( [{ base_experience: 112, pokemon: "pikachu" }] )
          expect(service.unknown_pokemons).to eq( ["unknown-pokemon", "unknown"] )
        end
      end
    end
  end
end
