require 'json'

def lambda_handler(event:, context:)
  begin
    body = JSON.parse(event['body'] || '{}')
    cpf = body['cpf']

    if cpf.nil? || cpf.empty?
      return { statusCode: 422, body: JSON.generate({ message: 'CPF é obrigatório.' }) }
    end

    if valid_cpf?(cpf)
      api_gateway_url = ENV['API_GATEWAY_URL']
      new_route = "#{api_gateway_url}/orders"

      {
        statusCode: 200,
        body: JSON.generate(
          {
            next_url: new_route,
            next_url_method: "POST",
          }
        )
      }
    else
      { statusCode: 422, body: JSON.generate({ message: 'CPF inválido.' }) }
    end
  rescue StandardError => error
    { statusCode: 500, body: JSON.generate({ message: 'Erro interno do servidor.' }) }
  end
end

def valid_cpf?(cpf)
  cpf = cpf.gsub(/[^0-9]/, '')
  return false unless cpf.length == 11 && cpf !~ /^(\d)\1{10}$/

  digits = cpf.chars.map(&:to_i)
  factors1 = (10.downto(2)).to_a
  factors2 = (11.downto(2)).to_a

  sum1 = digits[0..8].zip(factors1).map { |a, b| a * b }.sum
  dv1 = (sum1 * 10 % 11) % 10

  sum2 = digits[0..9].zip(factors2).map { |a, b| a * b }.sum
  dv2 = (sum2 * 10 % 11) % 10

  dv1 == digits[9] && dv2 == digits[10]
end
