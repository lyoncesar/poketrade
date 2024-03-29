# frozen_string_literal: true

require 'poke-api-v2'

module PokemonApi
  class Client
    def get(pokemon)
      PokeApi.get(pokemon: pokemon)
    rescue URI::InvalidURIError, JSON::ParserError
      nil
    end
  end
end
