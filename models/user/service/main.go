package userclient

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"server-structs/models/user/dto"

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

func (s *Service) Create(dto *dto.Create) (*dto.Response, error) {
	return s.sendRequest("POST", "/users", dto)
}

func (s *Service) Get(id string) (*dto.Response, error) {
	return s.sendRequest("GET", "/users/"+id, nil)
}

func (s *Service) Update(id string, dto *dto.Create) (*dto.Response, error) {
	return s.sendRequest("PUT", "/users/"+id, dto)
}

func (s *Service) Delete(id string) (*dto.Response, error) {
	return s.sendRequest("DELETE", "/users/"+id, nil)
}

func (s *Service) List() (*dto.Response, error) {
	return s.sendRequest("GET", "/users", nil)
}

func (s *Service) sendRequest(method, path string, body interface{}) (*dto.Response, error) {
	var buf *bytes.Buffer
	if body != nil {
		data, err := json.Marshal(body)
		if err != nil {
			return nil, fmt.Errorf("failed to marshal body: %w", err)
		}
		buf = bytes.NewBuffer(data)
	} else {
		buf = &bytes.Buffer{}
	}

	req, err := http.NewRequest(method, s.BaseURL+path, buf)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	if s.Token != "" {
		req.Header.Set("Authorization", "Bearer "+s.Token)
	}

	resp, err := s.Client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("request failed: %w", err)
	}
	defer resp.Body.Close()

	var response dto.Response
	if err := json.NewDecoder(resp.Body).Decode(&response); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	return &response, nil
}
