package models

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" //for postgres driver
)

//Vendor struct for crud
type Vendor struct {
	//for crud in organization
	Vendorid int    `json:"venid"`
	Email    string `json:"email"`
	Name     string `json:"name"`
	Address  string `json:"address"`
	Contact  string `json:"contact"`
	Orgid    int    `json:"orgid"`
}

//InsertVen to execute normal insert queries
func InsertVen(db *sql.DB, vendor *Vendor) (sql.Result, error) {
	return db.Exec(
		fmt.Sprintf("insert into vendor(email, name,address, contact,organization_id) values('%s','%s','%s','%s','%d')",
			vendor.Email,
			vendor.Name,
			vendor.Address,
			vendor.Contact,
			vendor.Orgid,
		),
	)
}

//DeleteVen to delete selected entry
func DeleteVen(db *sql.DB, venid int) (sql.Result, error) {
	if venid == -1 {
		return db.Exec(fmt.Sprintf("truncate table vendor"))
	}

	return db.Exec(fmt.Sprintf("delete from vendor where vendor_id=%d", venid))

}

//GetVen to get selected entry
func GetVen(db *sql.DB, venid int) (*sql.Rows, error) {
	if venid == -1 {
		return db.Query(fmt.Sprintf("select *from vendor"))
	}
	return db.Query(fmt.Sprintf("select *from vendor where vendor_id=%d", venid))
}

//GetVenOrg get the vendor organization
func GetVenOrg(db *sql.DB, orgid, venid int) (*sql.Rows, error) {
	if venid == -1 {
		return db.Query(fmt.Sprintf("select * from vendor where organization_id=%d", orgid))
	}
	return db.Query(fmt.Sprintf("select * from vendor where vendor_id=%d AND organization_id=%d", venid, orgid))
}

//UpdateVen to update selected entry
func UpdateVen(db *sql.DB, query string) (sql.Result, error) {
	fmt.Println(query)
	return db.Exec(query)
}
