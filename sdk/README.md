# SDK Template

Este repositório fornece um **template base para criação de SDKs** em diferentes linguagens.
Ele serve como ponto de partida para padronizar estrutura, documentação e boas práticas no desenvolvimento.

## Objetivo

- Facilitar a criação de novos SDKs de forma consistente.
- Oferecer uma estrutura inicial organizada e extensível.
- Acelerar o desenvolvimento e a integração com APIs.

## Como Utilizar

1. **Clone o repositório:**

```bash
git clone https://github.com/seu-usuario/sdk-template.git
cd sdk-template/projects/sdk
```

2. **Baixe dependências:**

```bash
go mod tidy
```

3. **Executar o SDK ou testes:**

```bash
go run main.go
```

## Exemplo de Uso

Após criar seu SDK a partir deste template, você pode utilizá-lo da seguinte forma:

```go
package main

import (
  "fmt"
  "log"
  "server-structs/modules/user/dto"
  "server-structs/modules/user/service"
)

func main() {
  baseURL := "http://localhost:8080"
  token := "your_api_token_here"
  service := service.NewService(baseURL, token)

  newUser := &dto.Create{
    Name: "John Doe",
    Email: "johndoe@example.com",
    Password: "securepassword",
    Owner: "admin",
    Role: "user",
  }

  response, err := service.Create(newUser)
  if err != nil {
    log.Fatalf("Failed to create user: %v", err)
  }

  fmt.Println("User created successfully:")
  fmt.Printf("ID: %s\nName: %s\nEmail: %s\nRole: %s\nOwner: %s\n",
    response.ID, response.Name, response.Email, response.Role, response.Owner)
}
```

## Boas Práticas

- Organizar módulos por domínio (ex.: `user`, `product`, `order`).
- Manter DTOs separados das entidades de negócio.
- Centralizar a lógica do módulo em `service/`.
- Documentar funções públicas e manter exemplos claros.
- Escrever testes unitários e de integração.

## Licença

Este projeto está sob a licença MIT. Consulte o arquivo LICENSE para mais detalhes.
