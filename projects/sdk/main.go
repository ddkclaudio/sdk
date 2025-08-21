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

	userService := service.NewService(baseURL, token)

	newUser := &dto.Create{
		Name:     "John Doe",
		Email:    "johndoe@example.com",
		Password: "securepassword",
		Owner:    "admin",
		Role:     "user",
	}

	response, err := userService.Create(newUser)
	if err != nil {
		log.Fatalf("Failed to create user: %v", err)
	}

	fmt.Println("User created successfully:")
	fmt.Printf("ID: %s\nName: %s\nEmail: %s\nRole: %s\nOwner: %s\n",
		response.ID, response.Name, response.Email, response.Role, response.Owner)
}
