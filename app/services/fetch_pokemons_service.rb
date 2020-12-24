require 'poke-api-v2'

class FetchPokemonsService

  def initialize(pokemons)
    @sending = pokemons.dig(:sending)
    @receiving = pokemons.dig(:receiving)
    @unknown_list = []
  end

  def updated_send
    validated_sending_list.compact
  end

  def updated_receive
    validated_receiving_list.compact
  end

  def unknown_pokemons
    updated_send
    updated_receive

    @unknown_list.compact
  end

  private

  attr_reader :sending, :receiving

  def validated_sending_list
    @validate_sendig_list ||= fetch_pokemons(sending)
  end

  def validated_receiving_list
    @validated_receiving_list ||= fetch_pokemons(receiving)
  end

  def fetch_pokemons(poke_list)
    poke_list.map do |name|
      pokemon = poke_api_get(name)

      if pokemon.blank?
        @unknown_list << name unless @unknown_list.include?(name)
        next
      end

      {
        pokemon: pokemon.forms.first.name,
        base_experience: pokemon.base_experience
      }
    end
  end

  def poke_api_get(name)
    begin
      PokeApi.get(pokemon: name.sub(/[$'$.]/, '').downcase.tr(' ', '-'))
    rescue URI::InvalidURIError, JSON::ParserError
      return
    end
  end
end
