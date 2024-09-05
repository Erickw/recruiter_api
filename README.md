# Recruiter API

API de recrutadores, trabalho e submissões em Ruby on Rails que implementa operações CRUD, geração de tokens seguros utilizando JWT e troca de senha utilizando PostgreSQL no formato de API REST.

## Funcionalidades

- Registro de novo usuário/recrutador e token especifico JWT;
- Login de usuário/recrutador e partir da validação das respectivas credênciais;
- CRUD de Recrutador;
- CRUD de Jobs (trabalhos) interno namespace `recruiter` ;
- Middleware para *autorização* de rotas protegidas.
- Busca personalizada de Jobs em namespace público, por status ativo e
título, descrição, ou skills;
- Listagem de detalhes de uma vaga em namespace público via ID da vaga (job);
- CRUD de Submission (aplicação) para uma vaga em namespace público, com limitação
de uma aplicação por email pra cada vaga.

## Configuração

### Pré-requisitos

- Ruby 2.7.2
- Rails 6.0
- PostgreSQL

### Instalação

1. Clone o repositório:

 ```sh
 git clone git@github.com:Erickw/recruiter_api.git
 cd microservice_auth
 ```

2. Instale as dependências:

 ```sh
 bundle install
 ```

3. Configure o banco de dados:

 ```sh
 rails db:create
 rails db:migrate
 ```

4. Configure as variáveis de ambiente:

 Crie um arquivo `.env` na raiz do projeto e defina as variáveis abaixo, para evitar inconsistências,
 também é recomendado atualizar os arquivos `.env.test.local` e `.env.development.local` com seus valores.

 ```env
 DATABASE_USERNAME
 DATABASE_PASSWORD
 SECRET_KEY_BASE
 JWT_EXPIRE_HOURS
 RAILS_ENV
 ```
 Para definir o periodo de expiração padrão do token em horas, basta preencher a váriavel `JWT_EXPIRE_HOURS` com um valor inteiro.
## Testes

### Executando Testes

- Para executar os testes, rode no terminal:

```sh
bundle exec rspec
```

## Uso

#### Execute o servidor localmente com o seguinte comando:

```sh
bundle exec rails s
```

### Endpoints Autenticação

#### Sign Up

- **URL:** `/signup`
- **Método:** `POST`
- **Descrição:** Cria um novo recrutador.

**Request:**

```sh
curl -X POST http://localhost:3000/signup -H "Content-Type: application/json" -d '{"recruiter":{
 "name": "John Doe",
 "email": "john@example.com",
 "password": "password",
}}'
```

**Response:**

```json
{
 "message": "Account created successfully",
 "token": {
 "token": "eyJhbGciOiJIUzI1NiJ9...",
 "exp": "2024-06-21T14:52:00Z"
 }
}
```

#### Sign In

- **URL:** `/signin`
- **Método:** `POST`
- **Descrição:** Autentica um usuário e gera um token.

**Request:**

```sh
curl -X POST http://localhost:3000/signin -H "Content-Type: application/json" -d '{
 "email": "john@example.com",
 "password": "password"
}'
```

**Response:**

```json
{
 "token": "eyJhbGciOiJIUzI1NiJ9...",
 "exp": "2024-06-22T14:52:00Z"
}
```

**Erros Possíveis:**

- **Usuário não encontrado:**

 ```json
 {
 "error": "User not found"
 }
 ```

- **Credenciais inválidas:**

 ```json
 {
 "error": "Invalid email or password"
 }
 ```

- **Token inválido:**

 ```json
 {
 "error": "Signature verification failed"
 }
 ```

- **Token expirado:**

 ```json
 {
 "error": "Signature has expired"
 }
 ```

#### Reset Password

- **URL:** `/reset_password`
- **Método:** `POST`
- **Descrição:** Redefine a senha de um recrutador.

**Request:**

```sh
curl --location 'http://localhost:3000/reset_password/' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <TOKEN>' \
--data-raw '{
 "email": "john@example.com",
 "password": "password123",
 "new_password": "password321"
}'
```

**Response:**

```json
{
 "message": "Password updated successfully"
}
```

## Exemplos de requisições internas de Recruiters

### 1. **Listar Recrutadores**

**Método:** `GET`
**URL:** `/recruiter/recruiters`
**Requisição cURL:**
```bash
curl -X GET "http://localhost:3000/recruiter/recruiters?page=1&per_page=10"
```

### 2. **Mostrar um Recrutador Específico**

**Método:** `GET`
**URL:** `/recruiter/recruiters/:id`
**Requisição cURL:**
```bash
curl -X GET http://localhost:3000/recruiter/recruiters/1
```

### 3. **Atualizar um Recrutador**

**Método:** `PUT`
**URL:** `/recruiter/recruiters/:id`
**Requisição cURL:**
```bash
curl -X PUT http://localhost:3000/recruiter/recruiters/1 \
 -H "Content-Type: application/json" \
 -d '{"name": "New Name", "email": "newemail@example.com", "password": "newpassword"}'
```

### 4. **Deletar um Recrutador**

**Método:** `DELETE`
**URL:** `/recruiter/recruiters/:id`
**Requisição cURL:**
```bash
curl -X DELETE http://localhost:3000/recruiter/recruiters/1
```

## Exemplos de requisições internas da área de Jobs dos Recruiters

### 1. **Listar Jobs**

**Método:** `GET`
**URL:** `/recruiter/jobs`
**Requisição cURL:**
```bash
curl -X GET "http://localhost:3000/recruiter/jobs?page=1&per_page=10"
```

### 2. **Mostrar um Job Específico**

**Método:** `GET`
**URL:** `/recruiter/jobs/:id`
**Requisição cURL:**
```bash
curl -X GET http://localhost:3000/recruiter/jobs/1
```

### 3. **Criar um Novo Job**

**Método:** `POST`
**URL:** `/recruiter/jobs`
**Requisição cURL:**
```bash
curl -X POST http://localhost:3000/recruiter/jobs \
 -H "Content-Type: application/json" \
 -d '{"title": "Software Developer", "description": "Develop software", "start_date": "2024-09-01", "end_date": "2024-12-31", "status": "open", "skills": ["Ruby", "Rails"], "recruiter_id": 1}'
```

### 4. **Atualizar um Job**

**Método:** `PUT`
**URL:** `/recruiter/jobs/:id`
**Requisição cURL:**
```bash
curl -X PUT http://localhost:3000/recruiter/jobs/1 \
 -H "Content-Type: application/json" \
 -d '{"title": "Senior Software Developer", "description": "Develop advanced software", "start_date": "2024-09-01", "end_date": "2024-12-31", "status": "open", "skills": ["Ruby", "Rails", "JavaScript"], "recruiter_id": 1}'
```

### 5. **Deletar um Job**

**Método:** `DELETE`
**URL:** `/recruiter/jobs/:id`
**Requisição cURL:**
```bash
curl -X DELETE http://localhost:3000/recruiter/jobs/1
```

### Observação:

É importante adicionar o seguinte cabeçalho para as requisições acima, uma vez que exigem autenticação:

```bash
-H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Exemplos de requisições **públicas** da API de Jobs

### 1. **Listar Jobs com status `open` e filtrar por título, descrição, ou skills**

**Método:** `GET`
**URL:** `/public/jobs`
**Requisição cURL:**
```bash
curl -X GET "http://localhost:3000/public/jobs?page=1&per_page=10&query=developer"
```

### 2. **Retorno dos detalhes de uma vaga (job) a partir do id**

**Método:** `GET`
**URL:** `/public/jobs/:id`
**Requisição cURL:**
```bash
curl -X GET http://localhost:3000/public/jobs/1
```

### Observação:

- **No caso do `index`**, `query` é um parâmetro opcional que pode ser usado para filtrar jobs com base em uma busca textual, enquanto `page` e `per_page` são usados para paginação em todas requisições da aplicação.

## Exemplos de requisições **públicas** da API de Submissões a uma vaga (job)

### 1. **Listar Submissões**

**Método:** `GET`
**URL:** `/public/submissions`
**Requisição cURL:**
```bash
curl -X GET "http://localhost:3000/public/submissions?page=1&per_page=10"
```

### 2. **Mostrar uma Submissão Específica**

**Método:** `GET`
**URL:** `/public/submissions/:id`
**Requisição cURL:**
```bash
curl -X GET http://localhost:3000/public/submissions/1
```

### 3. **Criar uma Nova Submissão**

**Método:** `POST`
**URL:** `/public/submissions`
**Requisição cURL:**
```bash
curl -X POST http://localhost:3000/public/submissions \
 -H "Content-Type: application/json" \
 -d '{"name": "John Doe", "email": "john.doe@example.com", "mobile_phone": "1234567890", "resume": "base64encodedresume", "job_id": 1}'
```

### 4. **Atualizar uma Submissão**

**Método:** `PUT`
**URL:** `/public/submissions/:id`
**Requisição cURL:**
```bash
curl -X PUT http://localhost:3000/public/submissions/1 \
 -H "Content-Type: application/json" \
 -d '{"name": "John Doe", "email": "john.doe@example.com", "mobile_phone": "0987654321", "resume": "newbase64encodedresume"}'
```

### 5. **Deletar uma Submissão**

**Método:** `DELETE`
**URL:** `/public/submissions/:id`
**Requisição cURL:**
```bash
curl -X DELETE http://localhost:3000/public/submissions/1
```

### Observação:

Não é possivel que o mesmo usuário (email) faça mais de uma submissão para uma mesma vaga (job).