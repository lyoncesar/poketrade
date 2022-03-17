# frozen_string_literal: true

module Filter
  # Fetch pokemons on external api
  class PokemonsService

    def initialize(pokemons: [], poke_api_client: PokeApi::Client.new())
      @pokemons = pokemons
      @poke_api_client = poke_api_client
      @unknown_list = []
    end

    def call
      OpenStruct.new(found: fetch_pokemons(@pokemons), not_found: @unknown_list)
    end

    private

    def fetch_pokemons(list)
      pokemon = Struct.new(:name, :base_experience)

      list.map do |name|
        response = @poke_api_client.get(name)

        if response.blank?
          @unknown_list << name unless @unknown_list.include?(name)
          next
        end

        pokemon.new(response.forms.first.name, response.base_experience)
      end.compact
    end
  end
end
