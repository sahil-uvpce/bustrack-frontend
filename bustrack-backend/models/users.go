package models

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" //for postgres driver
)

//Users struct for crud
type Users struct {
	Userid   int    `json:"userid"`
	Email    string `json:"email"`
	Password string `json:"password"`
	Orgid    int    `json:"orgid"`
}

//InsertUser to execute normal insert queries
func InsertUser(db *sql.DB, user *Users) (sql.Result, error) {
	return db.Exec(
		fmt.Sprintf("insert into users(email, password,  organization_id) values('%s','%s',%d)",
			user.Email,
			user.Password,
			user.Orgid,
		),
	)
}

//DeleteUser to delete selected entry
func DeleteUser(db *sql.DB, userid int) (sql.Result, error) {
	if userid == -1 {
		return db.Exec(fmt.Sprintf("truncate table users"))
	}

	return db.Exec(fmt.Sprintf("delete from users where user_id=%d", userid))

}

//GetUsers to get selected entry
func GetUsers(db *sql.DB, userid int) (*sql.Rows, error) {
	if userid == -1 {
		return db.Query(fmt.Sprintf("select * from users"))
	}
	return db.Query(fmt.Sprintf("select * from users where user_id=%d", userid))
}

//GetUserOrg get the usr by organization
func GetUserOrg(db *sql.DB, orgid, userid int) (*sql.Rows, error) {
	if orgid == -1 {
		return db.Query(fmt.Sprintf("select * from route where organization_id=%d", orgid))
	}
	return db.Query(fmt.Sprintf("select * from users where user_id=%d AND organization_id=%d", userid, orgid))
}

//UpdateUsers to update selected entry
func UpdateUsers(db *sql.DB, query string) (sql.Result, error) {
	return db.Exec(query)
}
