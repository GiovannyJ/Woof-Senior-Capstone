package database

import "golang.org/x/crypto/bcrypt"

/*
*TESTED WORKING
Hashed a password to be entered into database when account is created
returns string version of hash password and error if applicable
*/
func HashPassword(password interface{}) (string, error) {
	pwd, ok := password.(string)
	if ok {
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(pwd), 8)
		if err != nil {
			return "", err
		}
		return string(hashedPassword), nil
	}
	return "", bcrypt.ErrPasswordTooLong
}

/*
* TESTED WORKING
Verifies if password entered is same as one in database
returns error if applicable
*/
func VerifyPassword(password []byte, hashedPassword []byte) error {
	return bcrypt.CompareHashAndPassword(hashedPassword, password)
}