package models

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq" //for postgres driver
)

//Bus struct for crud
type Bus struct {
	Busid         int    `json:"busid"`
	Venid         int    `json:"venid"`
	CurrentTripid int    `json:"current_trip_id"`
	VehicleNo     string `json:"vehicle_no"`
}

//InsertBus to execute normal insert queries
func InsertBus(db *sql.DB, bus *Bus) (sql.Result, error) {
	return db.Exec(
		fmt.Sprintf("insert into bus(vendor_id,vehicle_no) values(%d,'%s')",
			bus.Venid,
			bus.VehicleNo,
		),
	)
}

//DeleteBus to delete selected entry
func DeleteBus(db *sql.DB, busid int) (sql.Result, error) {
	if busid == -1 {
		return db.Exec(fmt.Sprintf("truncate table bus"))
	}

	return db.Exec(fmt.Sprintf("delete from bus where bus_id=%d", busid))

}

//GetBus to get selected entry
func GetBus(db *sql.DB, busid int) (*sql.Rows, error) {
	if busid == -1 {
		return db.Query(fmt.Sprintf("select * from bus"))
	}
	return db.Query(fmt.Sprintf("select * from bus where bus_id=%d", busid))
}

//GetBusVen get the bus by vendor
func GetBusVen(db *sql.DB, vendorid int) (*sql.Rows, error) {
	return db.Query(fmt.Sprintf("select * from bus where vendor_id=%d", vendorid))
}

//UpdateBus to update selected entry
func UpdateBus(db *sql.DB, query string) (sql.Result, error) {
	return db.Exec(query)
}
