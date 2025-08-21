package service

import (
	"net/http"
	"{{ getModuleName }}/modules/{{ .Title | toSnake }}/dto"
	"time"
)

type Service struct {
	BaseURL string
	Token   string
	Client  *http.Client
}

func NewService(baseURL, token string) *Service {
	return &Service{
		BaseURL: baseURL,
		Token:   token,
		Client:  &http.Client{Timeout: 10 * time.Second},
	}
}

func (s *Service) Create(req *dto.Create) (*dto.Response, error) {
	return s.sendRequest("POST", "/users", req)
}

func (s *Service) Get(id string) (*dto.Response, error) {
	return s.sendRequest("GET", "/users/"+id, nil)
}

func (s *Service) Update(id string, req *dto.Create) (*dto.Response, error) {
	return s.sendRequest("PUT", "/users/"+id, req)
}

func (s *Service) Delete(id string) (*dto.Response, error) {
	return s.sendRequest("DELETE", "/users/"+id, nil)
}

func (s *Service) List() (*dto.Response, error) {
	return s.sendRequest("GET", "/users", nil)
}
