package database

import (
	"strconv"
	"fmt"
	"reflect"
	"strings"
	"database/sql"
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
func AccountExist(id string, email string) bool{
    exist_acc := map[string]interface{}{"username": id, "email": email}

    exists, err := Users_GET(exist_acc, 1)
	if err != nil{
		return false
	}
    
    return len(exists) > 0
}

//* checks if user is attending event RETURNS true if they are and false if not
func AttendanceExist(userID int, eventID int) bool{
    var query = make(map[string]interface{})
	queryParams := map[string]string{	
		"eventID": 		strconv.Itoa(eventID),
		"userID":		strconv.Itoa(userID),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

    exists, err := attendance_GET(query)
	if err != nil{
		return false
	}
    
    return len(exists) > 0
}

//*this method is here as a helper bc we would never just return the userid and eventID might need it in the future
//*gets all attendance
func attendance_GET(params map[string]interface{}) ([]attendance, error) {
	var sql strings.Builder
	sql.WriteString("SELECT userID, eventID FROM attendance")
	sql.WriteString(GenSelectQuery(params, "", 0))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []attendance

	for result.Next() {
		var t attendance
		if err := result.Scan(
			&t.UserID,
			&t.EventID,
		); err != nil {
			return values, err
		}
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}



//* executes SQL string
func execute(sql string) error{
	result, err := connect(sql)
	if err !=nil{
		return err
	}
	defer result.Close()
	return nil
}


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
		} else if columnName == "imgid" {
			// Handle imgID differently for sql.NullInt64 type
			if imgID, ok := columnValue.(sql.NullInt64); ok {
				if imgID.Valid {
					values = append(values, fmt.Sprintf("%d", imgID.Int64))
				} else {
					continue
				}
				continue
			}
		} else if b, ok := columnValue.(bool); ok {
			// Handle boolean values
			values = append(values, fmt.Sprintf("%t", b))
			columns = append(columns, columnName) // Include column name for boolean values
			continue
		}

		values = append(values, fmt.Sprintf("'%v'", columnValue))
		columns = append(columns, columnName)
	}

	sql := fmt.Sprintf("INSERT INTO %s(%s) VALUES(%s)", tableName, strings.Join(columns, ","), strings.Join(values, ","))
	return sql, nil
}


//* Helper function to check if a string is in a slice of strings
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


func GenSelectQuery_OR(params map[string]interface{}, columnName string, columnValue int) (string){
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
				sql.WriteString(strings.Join(conditions, " OR "))
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
				sql.WriteString(strings.Join(conditions, " OR "))
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