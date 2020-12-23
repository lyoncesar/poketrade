require 'poke-api-v2'

class FetchPokemonsService
  attr_reader :offering, :receiving

  def initialize(offering, receiving)
    @offering = offering
    @receiving = receiving
  end

  def call
    updated_offering_and_receiving
  end

  private

  def fair_trade?
    if (offering_experience - receiving_experience) > 10 || (offering_experience - receiving_experience) < -10
      return false
    end

    true
  end

  def offering_experience
    calculate_xp(fetch_poke_offering)
  end

  def receiving_experience
    calculate_xp(fetch_poke_receiving)
  end

  def calculate_xp(xp_array)
    xp = 0
    xp_array.each { |poke| xp += poke.dig(:base_experience) }

    xp
  end

  def updated_offering_and_receiving
    {
      offering: fetch_poke_offering,
      receiving: fetch_poke_receiving
    }
  end

  def fetch_poke_offering
    offering.map do |offer|
      pokemon = PokeApi.get(pokemon: offer.sub(/[$'$.]/, '').downcase.tr(' ', '-'))

      {
        pokemon: pokemon.forms.first.name,
        base_experience: pokemon.base_experience
      }
    end
  end

  def fetch_poke_receiving
    receiving.map do |receive|
      pokemon = PokeApi.get(pokemon: receive.underscore)

      {
        pokemon: pokemon.forms.first.name,
        base_experience: pokemon.base_experience
      }
    end
  end
end
