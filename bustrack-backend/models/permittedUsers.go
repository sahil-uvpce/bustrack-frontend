package models

import (
	"database/sql"
	"fmt"
	"strings"

	_ "github.com/lib/pq" //for postgres driver
)

//Permit struct for crud
type Permit struct {
	Organizationid int    `json:"orgid"`
	Email          string `json:"email"`
}

//InsertPerm to execute normal insert queries
func InsertPerm(db *sql.DB, per *Permit) (sql.Result, error) {
	return db.Exec(
		fmt.Sprintf("insert into permittedusers(organization_id, email) values(%d,'%s')",
			per.Organizationid,
			per.Email,
		),
	)
}

//DeletePerm to delete selected entry
func DeletePerm(db *sql.DB, email string) (sql.Result, error) {
	if strings.Compare(email, "all") == 0 {
		return db.Exec(fmt.Sprintf("truncate table permittedusers"))
	}

	return db.Exec(fmt.Sprintf("delete from permittedusers where email='%s'", email))

}

//GetPerm to get selected entry
func GetPerm(db *sql.DB, email string) (*sql.Rows, error) {
	return db.Query(fmt.Sprintf("select * from permittedusers where email='%s'", email))
}

//GetPermOrg get permittedusers by organization
func GetPermOrg(db *sql.DB, orgid int) (*sql.Rows, error) {
	return db.Query(fmt.Sprintf("select * from permittedusers where organization_id=%d", orgid))
}

//UpdatePerm to update selected entry
func UpdatePerm(db *sql.DB, query string) (sql.Result, error) {
	fmt.Println(query)
	return db.Exec(query)
}
