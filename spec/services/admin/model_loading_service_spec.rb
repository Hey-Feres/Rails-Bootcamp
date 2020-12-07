require 'rails_helper'

describe Admin::ModelLoadingService do
  context 'when #call' do
    # Dentro do nosso contexto raiz, já etamos criando uma lista de 15 categorias, que é o model que utilizaremos para testar o nosso service.
    let!(:categories) { create_list(:category, 15) }

    # Para o caso onde os parâmetros estão presentes, previmos duas validações:
    # - Uma para verificar que a quantidade de registros está correta, seguindo o tamanho da paginação
    # - E outra que os registros serão retornados seguindo a busca, ordenação e paginação corretas.
    context 'when params are present' do
      # Para conseguir seguir estas validações, criaremos uma lista de categorias que contenham a expressão "Search" no nome uma variável para os parâmetros que enviaremos para o service
      let!(:search_categories) do
        categories = []
        15.times { |n| categories << create(:category, name: "Search #{n + 1}") }
        categories
      end

      let(:params) do
        {search: {name: 'Search'}, order: {name: :desc}, page: 2, length: 4}
      end

      # Agora podemos adicionar o primeiro caso de teste que é verificar se a quantidade retornada corresponde ao tamanho da paginação.
      it 'returns right :length following pagination' do
        service = described_class.new(Category.all, params)
        result_categories = service.call
        expect(result_categories.count).to eq 4
      end

      # O segundo caso de teste é verificarmos se os registros retornados correspondem com o esperado.
      # Este teste, embora mais comprido é bem simples. Estamos pegando a lista de search_categories que criamos e ordenando de forma decrescente e extraindo dela os elementos de 4 a 7, que correspondem à pagina 2 de tamanho 4 que enviamos nos parâmetros. E por último estamos verificando se o que foi retornado do service contém exatamente o que esperamos.
      it 'returns records following search, order and pagination' do
        search_categories.sort! { |a,b| b[:name] <=> a[:name] }
        service = described_class.new(Category.all, params)
        result_categories = service.call
        expected_categories = search_categories[4..7]
        expect(result_categories).to contain_exactly *expected_categories
      end
    end

    # Para os testes sem parâmetros, validaremos dois casos mais simples: se ele retorna a quantidade padrão de registros, que são 10, e se os 10 primeiros registros são retornados.
    context 'when params are not present' do
      it 'return default :length pagination' do
        service = described_class.new(Category.all, nil)
        result_categories = service.call
        expect(result_categories.count).to eq 10
      end

      it 'return first 10 records' do
        service = described_class.new(Category.all, nil)
        result_categories = service.call
        expected_categories = categories[0..9]
        expect(result_categories).to contain_exactly *expected_categories
      end
    end
  end
end