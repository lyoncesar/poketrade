class TradeContract < Dry::Validation::Contract
  params do
    required(:receiving).value(:array, min_size?: 1).each do
      hash do
        required(:name).filled(:string)
      end
    end

    required(:sending).value(:array, min_size?: 1).each do
      hash do
        required(:name).filled(:string)
      end
    end
  end

  rule(:sending) do
    key.failure(
      'The trade is limited of 6 Pokemons over each side'
    ) if value.count > 6
  end

  rule(:receiving) do
    key.failure(
      'The trade is limited of 6 Pokemons over each side'
    ) if value.count > 6
  end
end
