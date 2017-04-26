package models

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" //for postgres driver
)

//Driver struct for crud
type Driver struct {
	Driverid int    `json:"drid"`
	Email    string `json:"email"`
	Vendorid int    `json:"venid"`
	Name     string `json:"name"`
	Address  string `json:"address"`
	Password string `json:"password"`
	Contact  string `json:"contact"`
}

//InsertDriver to execute normal insert queries
func InsertDriver(db *sql.DB, dr *Driver) (sql.Result, error) {
	query := fmt.Sprintf("insert into driver(email, vendor_id, name, address, password, contact) values('%s','%d','%s','%s','%s','%s')",
		dr.Email,
		dr.Vendorid,
		dr.Name,
		dr.Address,
		dr.Password,
		dr.Contact,
	)
	fmt.Println(query)
	return db.Exec(query)
}

//DeleteDriver to delete selected entry
func DeleteDriver(db *sql.DB, drid int) (sql.Result, error) {
	if drid == -1 {
		return db.Exec(fmt.Sprintf("truncate table driver"))
	}

	return db.Exec(fmt.Sprintf("delete from driver where driver_id=%d", drid))
}

//GetDriver to get selected entry
func GetDriver(db *sql.DB, drid int) (*sql.Rows, error) {
	if drid == -1 {
		return db.Query(fmt.Sprintf("select * from driver"))
	}
	return db.Query(fmt.Sprintf("select * from driver where driver_id=%d", drid))
}

//GetDriverbyVen get driver by vendor_id
func GetDriverbyVen(db *sql.DB, drid int, venid int) (*sql.Rows, error) {
	if drid == -1 {
		return db.Query(fmt.Sprintf("select * from driver where vendor_id=%d", venid))
	}
	return db.Query(fmt.Sprintf("select * from driver where driver_id=%d AND vendor_id=%d", drid, venid))
}

//UpdateDriver to update selected entry
func UpdateDriver(db *sql.DB, query string) (sql.Result, error) {
	fmt.Println(query)
	return db.Exec(query)
}
