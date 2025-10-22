**Mini-Oswaldo**

Mini-Oswaldo é uma aplicação web desenvolvida em Ruby on Rails, inspirada em sistemas de gestão de serviços de saúde domiciliar como o Beep Saúde. O projeto foi criado como um exercício de aprendizado, cobrindo desde a autenticação de usuários até a gestão de estoque e agendamentos com baixa automática.

Funcionalidades Principais:
- Autenticação Segura: Sistema de login para usuários internos (funcionários) utilizando a gem Devise. O cadastro público é desabilitado por segurança.
- Gerenciamento de Usuários: Interface administrativa para criar, visualizar, editar e excluir contas de usuários.
- Gestão de Entidades: CRUDs completos para:
  - Hubs: Centrais de distribuição ou bases operacionais.
  - Categorias: Classificação dos produtos (ex: Infantil, Adulto).
  - Produtos (Vacinas): Itens gerenciados, com nome, descrição, categoria e preço.
- Controle de Estoque:
  - Associação de produtos a hubs com quantidades específicas (StockItem).
  - Interface na página do Hub para adicionar ou remover itens do estoque.
- Sistema de Agendamentos:
  - Criação de agendamentos para pacientes, associados a um Hub e a um funcionário.
  - Possibilidade de adicionar múltiplos produtos (vacinas) a um único agendamento.
  - Validação de Estoque: O sistema verifica se o Hub possui a quantidade necessária de cada produto antes de confirmar o agendamento.
  - Baixa Automática: Funcionalidade para marcar um agendamento como "Concluído", que automaticamente subtrai os itens utilizados do estoque do Hub.
- Pesquisa: Funcionalidade para buscar agendamentos por ID ou data.
- Dashboard: Painel inicial que exibe um resumo do sistema, incluindo contagem de entidades e a receita total gerada por agendamentos concluídos.

Tecnologias Utilizadas:
- Backend: Ruby on Rails 8.0.3
- Frontend: HTML, CSS, JavaScript, Bootstrap 5, StimulusJS
- Banco de Dados: PostgreSQL
- Autenticação: Devise
- Assets: Sprockets

Configuração do Projeto:
Siga os passos abaixo para configurar o ambiente de desenvolvimento local.

Pré-requisitos
- Ruby (verificar versão no arquivo .ruby-version)
- Bundler (gem install bundler)
- Node.js e Yarn (para gestão de assets JavaScript)
- PostgreSQL (instalado e rodando)

Instalação
1. Clone o repositório:
  git clone https://github.com/caioabcoutinho/mini-oswaldo.git
  cd mini-oswaldo

2. Instale as dependências:
  bundle install
  yarn install # Ou npm install, dependendo da sua configuração

3. Configure o Banco de Dados:
- Certifique-se de que o PostgreSQL está rodando.
- Edite config/database.yml com suas credenciais de usuário e senha do PostgreSQL, se necessário.
- Crie o banco de dados e rode as migrações:
    rails db:create
    rails db:migrate
(Opcional) Popule o banco com dados iniciais:
    rails db:seed

4. Inicie o Servidor:
  rails s
A aplicação estará disponível em http://localhost:3000.

Primeiro Acesso
Como o cadastro público está desabilitado, você precisa criar seu primeiro usuário via console:
  rails c
  User.create(email: 'admin@exemplo.com', password: 'password', password_confirmation: 'password')
  exit

Agora você pode acessar http://localhost:3000/users/sign_in com essas credenciais.


**Como Usar**
1. Faça login com um usuário administrador.
2. Navegue pela sidebar para gerenciar Hubs, Categorias, Vacinas (Produtos) e Usuários.
3. Adicione preços às suas vacinas.
4. Vá até um Hub e adicione estoque aos produtos.
5. Crie Agendamentos, adicionando as vacinas necessárias.
6. Após um atendimento, marque o agendamento como "Concluído" para dar baixa no estoque.
7. Verifique o Dashboard para ver a receita atualizada.

Este README foi gerado para documentar os passos necessários para rodar a aplicação Mini-Oswaldo.
