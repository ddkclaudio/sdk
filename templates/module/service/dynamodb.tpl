package service

import (
	"context"
	"fmt"
	"strconv"

	"{{ getModuleName }}/modules/{{ .Title | toSnake }}/dto"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

type dynamodbService struct {
	client *dynamodb.Client
	table  string
}

func NewDynamoDBService(cfg aws.Config, tableName string) Service {
	client := dynamodb.NewFromConfig(cfg)
	return &dynamodbService{
		client: client,
		table:  tableName,
	}
}

func (s *dynamodbService) Create(req *dto.Create) (*dto.Response, error) {
	item, err := attributevalue.MarshalMap(req)
	if err != nil {
		return nil, fmt.Errorf("marshal create request: %w", err)
	}

	_, err = s.client.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String(s.table),
		Item:      item,
	})
	if err != nil {
		return nil, fmt.Errorf("create {{ .Title }}: %w", err)
	}

	resp := &dto.Response{}
	err = attributevalue.UnmarshalMap(item, resp)
	if err != nil {
		return nil, fmt.Errorf("unmarshal response: %w", err)
	}

	return resp, nil
}

func (s *dynamodbService) Get(id string) (*dto.Response, error) {
	result, err := s.client.GetItem(context.TODO(), &dynamodb.GetItemInput{
		TableName: aws.String(s.table),
		Key: map[string]types.AttributeValue{
			"id": &types.AttributeValueMemberS{Value: id},
		},
	})
	if err != nil {
		return nil, fmt.Errorf("get {{ .Title }}: %w", err)
	}
	if result.Item == nil {
		return nil, fmt.Errorf("item not found")
	}

	var resp dto.Response
	if err := attributevalue.UnmarshalMap(result.Item, &resp); err != nil {
		return nil, fmt.Errorf("unmarshal get result: %w", err)
	}

	return &resp, nil
}

func (s *dynamodbService) Update(id string, req *dto.Update) (*dto.Response, error) {
	updates := map[string]types.AttributeValue{}
	vals, err := attributevalue.MarshalMap(req)
	if err != nil {
		return nil, fmt.Errorf("marshal update request: %w", err)
	}
	for k, v := range vals {
		updates[k] = v
	}

	expr := ""
	attrNames := map[string]string{}
	attrValues := map[string]types.AttributeValue{}
	i := 0
	for k, v := range updates {
		placeholder := "#f" + strconv.Itoa(i)
		valuePlaceholder := ":v" + strconv.Itoa(i)
		if i > 0 {
			expr += ", "
		}
		expr += fmt.Sprintf("%s = %s", placeholder, valuePlaceholder)
		attrNames[placeholder] = k
		attrValues[valuePlaceholder] = v
		i++
	}

	_, err = s.client.UpdateItem(context.TODO(), &dynamodb.UpdateItemInput{
		TableName:                 aws.String(s.table),
		Key:                       map[string]types.AttributeValue{"id": &types.AttributeValueMemberS{Value: id}},
		UpdateExpression:          aws.String("SET " + expr),
		ExpressionAttributeNames:  attrNames,
		ExpressionAttributeValues: attrValues,
	})
	if err != nil {
		return nil, fmt.Errorf("update {{ .Title }}: %w", err)
	}

	return s.Get(id)
}

func (s *dynamodbService) Delete(id string) error {
	_, err := s.client.DeleteItem(context.TODO(), &dynamodb.DeleteItemInput{
		TableName: aws.String(s.table),
		Key:       map[string]types.AttributeValue{"id": &types.AttributeValueMemberS{Value: id}},
	})
	if err != nil {
		return fmt.Errorf("delete {{ .Title }}: %w", err)
	}
	return nil
}

func (s *dynamodbService) List(filter *dto.Filter) ([]*dto.Response, error) {
	var list []*dto.Response
	input := &dynamodb.ScanInput{
		TableName: aws.String(s.table),
		Limit:     aws.Int32(int32(filter.PageSize)),
	}

	if filter.Owner != "" {
		input.FilterExpression = aws.String("owner_id = :owner")
		input.ExpressionAttributeValues = map[string]types.AttributeValue{
			":owner": &types.AttributeValueMemberS{Value: filter.Owner},
		}
	}

	result, err := s.client.Scan(context.TODO(), input)
	if err != nil {
		return nil, fmt.Errorf("list {{ .Title }}: %w", err)
	}

	err = attributevalue.UnmarshalListOfMaps(result.Items, &list)
	if err != nil {
		return nil, fmt.Errorf("unmarshal list: %w", err)
	}

	return list, nil
}
