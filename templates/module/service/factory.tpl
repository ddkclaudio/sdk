package service

import (
	"gorm.io/gorm"
	"github.com/aws/aws-sdk-go-v2/aws"
)

func NewRestInstance(baseURL, token string) Service {
	return NewHTTPService(baseURL, token)
}

func NewPostgresInstance(db *gorm.DB) Service {
	return NewPostgresService(db)
}

func NewDynamoDBInstance(cfg aws.Config) Service {
	return NewDynamoDBService(cfg, "{{ .Title | toSnake }}")
}

