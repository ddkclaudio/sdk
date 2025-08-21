package service

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"{{ getModuleName }}/modules/{{ .Title | toSnake }}/dto"
	"time"
)

type httpService struct {
	BaseURL string
	Token   string
	Client  *http.Client
}

func NewHTTPService(baseURL, token string) Service {
	return &httpService{
		BaseURL: baseURL,
		Token:   token,
		Client:  &http.Client{Timeout: 10 * time.Second},
	}
}

func (s *httpService) sendRequest(method, path string, body, out interface{}) error {
	var buf io.Reader
	if body != nil {
		b, err := json.Marshal(body)
		if err != nil {
			return fmt.Errorf("serialize request: %w", err)
		}
		buf = bytes.NewBuffer(b)
	}

	req, err := http.NewRequest(method, s.BaseURL+path, buf)
	if err != nil {
		return fmt.Errorf("create request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	if s.Token != "" {
		req.Header.Set("Authorization", "Bearer "+s.Token)
	}

	resp, err := s.Client.Do(req)
	if err != nil {
		return fmt.Errorf("request error: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode < http.StatusOK || resp.StatusCode >= http.StatusMultipleChoices {
		data, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("request failed: status=%d, body=%s", resp.StatusCode, string(data))
	}

	if out != nil {
		return json.NewDecoder(resp.Body).Decode(out)
	}
	return nil
}

func (s *httpService) doWithResponse(method, path string, body interface{}) (*dto.Response, error) {
	var resp dto.Response
	if err := s.sendRequest(method, path, body, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}

func (s *httpService) Create(req *dto.Create) (*dto.Response, error) {
	return s.doWithResponse("POST", "/files", req)
}

func (s *httpService) Get(id string) (*dto.Response, error) {
	return s.doWithResponse("GET", "/files/"+id, nil)
}

func (s *httpService) Update(id string, req *dto.Update) (*dto.Response, error) {
	return s.doWithResponse("PUT", "/files/"+id, req)
}

func (s *httpService) Delete(id string) error {
	return s.sendRequest("DELETE", "/files/"+id, nil, nil)
}

func (s *httpService) List(filter *dto.Filter) ([]*dto.Response, error) {
	var list []*dto.Response
	if err := s.sendRequest("GET", "/files", filter, &list); err != nil {
		return nil, err
	}
	return list, nil
}
