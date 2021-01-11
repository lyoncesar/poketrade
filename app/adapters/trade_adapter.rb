class TradeAdapter
  def initialize(params)
    @params = params
  end

  def receiving
    filter_names(params.dig(:receiving))
  end

  def sending
    filter_names(params.dig(:sending))
  end

  def avg_receiving
    return 0 if params.dig(:avg_receiving).blank?

    params.dig(:avg_receiving)
  end

  def avg_sending
    return 0 if params.dig(:avg_sending).blank?

    params.dig(:avg_sending)
  end

  private

  attr_reader :params

  # remove all special characters, apply downcase and overwrite trailing space with '-'.
  def filter_names(pokemons)
    pokemons.map do |name|
      name.sub(/[^a-zA-Z0-9]/, '').downcase.tr(' ', '-') unless name.blank?
    end.compact
  end
end
