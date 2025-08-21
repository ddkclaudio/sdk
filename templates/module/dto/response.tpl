package dto

type Response struct {
{{- range $name, $prop := .Properties }}
  {{- $type := JSONTypeToGoType $prop.Type }}
  {{- if not (isRequired $name $.Required) }}
  {{ $name | toPascal }} *{{ $type }} `json:"{{ toSnake $name }}"` 
  {{- else }}
  {{ $name | toPascal }} {{ $type }} `json:"{{ toSnake $name }}"` 
  {{- end }}
{{- end }}
}

func New() *Response {
	return &Response{}
}

func (e Response) Validate() error {
	return nil
}
