require 'rails_helper'

RSpec.describe PokemonApi::Client do
  describe '#get' do
    context 'when found pokemon' do
      it 'return it' do
        client = described_class.new()
        VCR.use_cassette('poke_api/fetch_pokemon') do
          response = client.get('pikachu')
          expect(response.forms.first.name).to eq('pikachu')
        end
      end
    end

    context 'when not found pokemon' do
      before do
        allow_any_instance_of(PokeApi).to receive(:get).and_raise(URI::InvalidURIError)
      end
      it 'return nil' do
        client = described_class.new
        expect(client.get('picachu')).to be_nil
      end
    end
  end
end
