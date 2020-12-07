# Como sabemos, o service é o PORO (Pure and Old Ruby Object), um objeto puro do Ruby.
# Então para a implementação o service, vamos começar criando o método construtor,
# que como vimos nos testes, vai receber um model que já implemente search_by_name e paginate
module Admin
  class ModelLoadingService
    def initialize(searchable_model, params={})
      @searchable_model = searchable_model
      @params = params
      @params ||= {}
    end

    def call
      @searchable_model.search_by_name(@params.dig(:search, :name))
                       .order(@params[:order].to_h)
                       .paginate(@params[:page].to_i, @params[:length].to_i)
    end
  end
end

# E vou aproveitar para explicar um conceito bem interessante que é utilizado no Ruby.
# Nós estamos chamando neste service dois métodos search_by_name e paginate (e podemos
# colocar o order no meio também) de um objeto que a gente não faz idéia se implementa ou não.
# Isso é chamando de Duck Typing, onde a gente pensa que "se quaqueja como um pato, então deve ser
# um pato", ou seja, não estamos preocupados se um objeto é do tipo X ou Y, nós inferimos que ele
# implementa o método que chamamos.

# Como no Ruby não existe o conceito de interface, embora a gente possa simular uma, não é comum que
# obriguemos um objeto a implementar um determinado método, nós apenas inferimos que sim, como no caso
# deste service, nós estamos inferindo que search_by_name, order e paginate já são implementados.
# No nosso caso isso ocorre por meio do ActiveRecord e dos concerns que criamos, mas na verdade pro service
# não importa a origem, desde que eles existam.