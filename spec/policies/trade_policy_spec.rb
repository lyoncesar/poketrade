require 'rails_helper'

RSpec.describe TradePolicy do
  context 'fair trade' do
    let(:trade_updated_send) do
        [
          {base_experience: 132, pokemon: "farfetchd"},
          {base_experience: 112, pokemon: "pikachu"},
          {base_experience: 62, pokemon: "charmander"}
        ]
    end

    let(:trade_updated_receive) do
      [
        {base_experience: 112, pokemon: "pikachu"},
        {base_experience: 62, pokemon: "charmander"},
        {base_experience: 179, pokemon: "sandaconda"},
        {base_experience: 49, pokemon: "zubat"}
      ]
    end

    let(:trade_unknown_pokemons) { [] }

    before do
      trade = instance_double(FetchPokemonsService)
    end

    it 'respond with a true fair_trade' do
      trade = instance_double(
        FetchPokemonsService,
        :updated_send => trade_updated_send,
        :updated_receive => trade_updated_receive,
        :unknown_pokemons => trade_unknown_pokemons
      )
      policy = described_class.new(trade)

      expect(policy.call).to eq(
        {
          trade: {
            sending: [
              {base_experience: 132, pokemon: "farfetchd"},
              {base_experience: 112, pokemon: "pikachu"},
              {base_experience: 62, pokemon: "charmander"}
            ],
            receiving: [
              {base_experience: 112, pokemon: "pikachu"},
              {base_experience: 62, pokemon: "charmander"},
              {base_experience: 179, pokemon: "sandaconda"},
              {base_experience: 49, pokemon: "zubat"}
            ]
          },
          fair_trade: true,
          average_xp_send: 102,
          average_xp_receive: 100,
          unknown_pokemons: []
        }
      )
    end 
  end

  context 'when none pokemon was found' do
    let(:trade_unknown_pokemons) { ['unknow', 'unknown_pokemon'] }

    it 'return a list of unknown_pokemons' do
      trade = instance_double(
        FetchPokemonsService,
        :updated_receive => [],
        :updated_send => [],
        :unknown_pokemons => trade_unknown_pokemons
      )

      policy = described_class.new(trade)

      expect(policy.call).to eq(
        {
          trade: {
            sending: [],
            receiving: []
          },
          fair_trade: false,
          average_xp_send: 0,
          average_xp_receive: 0,
          unknown_pokemons: ['unknow', 'unknown_pokemon']
        }
      )
    end
  end

  context 'unfair trade' do
    let(:trade_updated_send) do
      [
        {base_experience: 132, pokemon: "farfetchd"},
        {base_experience: 112, pokemon: "pikachu"},
        {base_experience: 62, pokemon: "charmander"},
        {base_experience: 122, pokemon: "wooloo"},
        {base_experience: 227, pokemon: "nidoking"},
        {base_experience: 158, pokemon: "venomoth"}
      ]
    end
    let(:trade_updated_receive) do
      [
        {base_experience: 112, pokemon: "pikachu"},
        {base_experience: 62, pokemon: "charmander"},
        {base_experience: 179, pokemon: "sandaconda"},
        {base_experience: 49, pokemon: "zubat"},
        {base_experience: 225, pokemon: "alakazam"},
        {base_experience: 66, pokemon: "drowzee"}
      ]
    end
    let(:trade_unknown_pokemons) { [] }

    it 'respond with a false fair_trade' do
      trade = instance_double(
        FetchPokemonsService,
        :updated_send=> trade_updated_send,
        :updated_receive=> trade_updated_receive,
        :unknown_pokemons=> trade_unknown_pokemons
      )
      policy = described_class.new(trade)

      expect(policy.call).to eq(
        {
          trade: {
            sending: [
              {base_experience: 132, pokemon: "farfetchd"},
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
          },
          fair_trade: false,
          average_xp_send: 135,
          average_xp_receive: 115,
          unknown_pokemons: []
        }
      )
    end
  end
end
