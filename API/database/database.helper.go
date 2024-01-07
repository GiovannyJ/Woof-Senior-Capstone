package database

import (
	"strconv"
	"fmt"
	"reflect"
	"strings"
)


//* checks if a business exists already
func BusinessExist(name string, location string) bool{
    var query = make(map[string]interface{})
	queryParams := map[string]string{	
		"businessName":  	name,
		"location": 		location,
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

    exists, err := Business_GET(query)
	if err != nil{
		return false
	}
    
    return len(exists) > 0
}

//* checks if user has this value already
func SavedBusinessExist(userID int, businessID int) bool{
    var query = make(map[string]interface{})
	queryParams := map[string]string{	
		"businessID": 		strconv.Itoa(businessID),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

    exists, err := SavedBusiness_GET(query, userID)
	if err != nil{
		return false
	}
    
    return len(exists) > 0
}

//* checks if the account exits already RETURNS true if account exits and false if not
func AccountExist(id string) bool{
    exist_acc := map[string]interface{}{"username": id}

    exists, err := Users_GET(exist_acc)
	if err != nil{
		return false
	}
    
    return len(exists) > 0
}

//* executes SQL string
// func execute(sql string) error{
// 	result, err := connect(sql)
// 	if err !=nil{
// 		return err
// 	}
// 	defer result.Close()
// 	return nil
// }


//* Generates generic insert query when columns and values are dynamic
func GenInsertQuery(tableName string, data interface{}, ignoreColumns []string) (string, error) {
    valueType := reflect.TypeOf(data)
    value := reflect.ValueOf(data)

    var columns []string
    var values []string

    for i := 0; i < valueType.NumField(); i++ {
        field := valueType.Field(i)
        columnName := strings.ToLower(field.Name)

        // Check if the column should be ignored
        if contains(ignoreColumns, columnName) {
            continue
        }

        columnValue := value.Field(i).Interface()

        if ptr, ok := columnValue.(*string); ok && ptr != nil {
            columnValue = *ptr
        } else if ptr, ok := columnValue.(*int); ok && ptr != nil {
            columnValue = *ptr
        }

        columns = append(columns, columnName)
        values = append(values, fmt.Sprintf("'%v'", columnValue))
    }

    sql := fmt.Sprintf("INSERT INTO %s(%s) VALUES(%s)", tableName, strings.Join(columns, ","), strings.Join(values, ","))
    return sql, nil
}

// Helper function to check if a string is in a slice of strings
func contains(slice []string, val string) bool {
    for _, item := range slice {
        if item == val {
            return true
        }
    }
    return false
}

//* Generates a SELECT query for any table, if columnName and value are provided it searches for those conditions as well
func GenSelectQuery(params map[string]interface{}, columnName string, columnValue int) (string){
	var sql strings.Builder
	if columnName == ""{
		if len(params) > 0 {
			var conditions []string
			var orderby string
	
			for name, value := range params {
				if name == "order" {
					orderby = fmt.Sprintf(" ORDER BY %s", value)
				} else {
					condition := fmt.Sprintf("%s='%v'", name, value)
					conditions = append(conditions, condition)
				}
			}
	
			if len(conditions) > 0 {
				sql.WriteString(" WHERE ")
				sql.WriteString(strings.Join(conditions, " AND "))
			}
	
			sql.WriteString(orderby)
		}
	}else{
		if len(params) > 0 {
			var conditions []string
			var orderby string
			for name, value := range params {
				if name == "order" {
					orderby = fmt.Sprintf(" ORDER BY %s", value)
				} else {
					condition := fmt.Sprintf("%s='%v'", name, value)
					conditions = append(conditions, condition)
				}
			}
			if len(conditions) > 0 {
				sql.WriteString(" WHERE ")
				sql.WriteString(strings.Join(conditions, " AND "))
				q := fmt.Sprintf(" AND %s = %d",columnName, columnValue)
				sql.WriteString(q)
			} else {
				q := fmt.Sprintf(" WHERE %s = %d",columnName, columnValue)
				sql.WriteString(q)
			}
			sql.WriteString(orderby)
		} else {
			q := fmt.Sprintf(" WHERE %s = %d", columnName, columnValue)
			sql.WriteString(q)
		}
	}

	return sql.String()
}
