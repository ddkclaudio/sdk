package service

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"{{ getModuleName }}/modules/{{ .Title | toSnake }}/dto"
)

func (s *Service) sendRequest(method, path string, body interface{}) (*dto.Response, error) {
	var buf io.Reader
	if body != nil {
		b, err := json.Marshal(body)
		if err != nil {
			return nil, formatRequestError(method, path, "failed to serialize request", err, 0, nil)
		}
		buf = bytes.NewBuffer(b)
	}

	req, err := http.NewRequest(method, s.BaseURL+path, buf)
	if err != nil {
		return nil, formatRequestError(method, path, "failed to create request", err, 0, nil)
	}
	req.Header.Set("Content-Type", "application/json")
	if s.Token != "" {
		req.Header.Set("Authorization", "Bearer "+s.Token)
	}

	resp, err := s.Client.Do(req)
	if err != nil {
		return nil, formatRequestError(method, path, "request error", err, 0, nil)
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		bodyBytes, _ := io.ReadAll(resp.Body)
		return nil, formatRequestError(method, path, "request failed", nil, resp.StatusCode, bodyBytes)
	}

	var result dto.Response
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, formatRequestError(method, path, "failed to decode Response", err, 0, nil)
	}

	return &result, nil
}

func formatRequestError(method, path, msg string, cause error, status int, body []byte) error {
	if status > 0 {
		return fmt.Errorf("%s [%s %s]: status=%d, body=%s", msg, method, path, status, string(body))
	}
	if cause != nil {
		return fmt.Errorf("%s [%s %s]: %w", msg, method, path, cause)
	}
	return fmt.Errorf("%s [%s %s]", msg, method, path)
}
