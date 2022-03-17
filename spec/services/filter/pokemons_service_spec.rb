require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Filter::PokemonsService do
  describe '#call' do
    let(:list) do
      [
        'farfetchd',
        'pikachu'
      ]
    end

    context 'when found pokemons' do
      it 'returns it on found attribute' do
        service = described_class.new(pokemons: list)

        VCR.use_cassette('fetch_pokemons') do
          pokemons = service.call
          expect(pokemons.found.first.name).to eq('farfetchd')
          expect(pokemons.found.first.base_experience).to eq(132)
        end
      end
    end

    context 'when not found pokemons' do
      let(:list) do
        [
          'picachu',
          'chamander'
        ]
      end

      before do
        allow_any_instance_of(PokeApi::Client).to receive(:get) { nil }
      end

      it 'returns the name on not_found attribute' do
        service = described_class.new(pokemons: list)
        expect(service.call.not_found).to eq(%w[picachu chamander])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
