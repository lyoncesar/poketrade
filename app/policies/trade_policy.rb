class TradePolicy
  def initialize(trade = FetchPokemonsService.new)
    @trade = trade
  end

  def call
    policy_report
  end

  private

  attr_reader :trade

  def policy_report
    {
      trade: {
        sending: trade.updated_send,
        receiving: trade.updated_receive
      },
      fair_trade: fair_trade?,
      average_xp_send: average_xp_send,
      average_xp_receive: average_xp_receive,
      unknown_pokemons: trade.unknown_pokemons
    }
  end 

  # A fair trade consist by the limit until 10 points of diference between xps
  def fair_trade?
    return false if average_xp_receive.zero? && average_xp_send.zero?

    (-10..10).include?(average_xp_send - average_xp_receive)
  end

  def average_xp_receive
    return 0 if trade.updated_receive.blank?

    calculate_xp(trade.updated_receive) / pokemons_count(trade.updated_receive)
  end

  def average_xp_send
    return 0 if trade.updated_send.blank?

    calculate_xp(trade.updated_send) / pokemons_count(trade.updated_send)
  end

  def calculate_xp(xp_list)
    xp = 0
    xp_list.each { |pokemon| xp += pokemon.dig(:base_experience) }

    xp
  end

  def pokemons_count(list)
    list.count
  end
end
