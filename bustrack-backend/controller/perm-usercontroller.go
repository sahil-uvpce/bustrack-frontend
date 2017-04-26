package controller

import (
	"bustrack/dbs"
	"bustrack/models"
	"bustrack/tools"
	"fmt"
	"net/http"
	"strconv"

	"github.com/labstack/echo"
	_ "github.com/lib/pq" //for postgres driver
)

// CreatePermUser create user
func CreatePermUser(c echo.Context) (err error) {
	pmuser := &models.Permit{
		Organizationid: stringtoInt(c.FormValue("orgid")),
		Email:          c.FormValue("email"),
	}

	if err = c.Bind(pmuser); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertPerm(dbs.DB, pmuser)
	tools.PanicIf(err)
	fmt.Println(result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "Permitted user is created")
	}
	return c.JSON(http.StatusNotFound, "Permitted user is not created")
}

//DeletePermUser delete the user by id
func DeletePermUser(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeletePerm(dbs.DB, c.Param("email"))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetPermUser get the vendor by id
func GetPermUserByEmail(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	fmt.Println("email:", c.QueryParam("email"))
	result, err := models.GetPerm(dbs.DB, c.QueryParam("email"))
	tools.PanicIf(err)
	pmusrs := make([]models.Permit, 0.0)
	pmusr := models.Permit{}
	for result.Next() {
		result.Scan(&pmusr.Organizationid, &pmusr.Email)
		fmt.Println(pmusr.Organizationid, pmusr.Email)
		pmusrs = append(pmusrs, pmusr)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, pmusrs)
}

//GetPermUserOrg get user organization
func GetPermUserOrg(c echo.Context) (err error) {
	result, err := models.GetPermOrg(dbs.DB, stringtoInt(c.Param("orgid")))
	tools.PanicIf(err)
	pmusrs := make([]models.Permit, 0.0)
	pmusr := models.Permit{}
	for result.Next() {
		result.Scan(&pmusr.Organizationid, &pmusr.Email)
		fmt.Println(pmusr.Organizationid, pmusr.Email)
		pmusrs = append(pmusrs, pmusr)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, pmusrs)
}

//UpdatePermUser update the vendor by id
func UpdatePermUser(c echo.Context) (err error) {
	pmuser := &models.Permit{
		Organizationid: stringtoInt(c.FormValue("orgid")),
		Email:          c.FormValue("email"),
	}
	if err = c.Bind(pmuser); err != nil {
		return err
	}
	orm := map[string]string{
		"organization_id": strconv.Itoa(pmuser.Organizationid),
	}
	query := tools.UpdateBuilder("permittedusers", orm, "email", pmuser.Email)
	//db := dbs.GetDB()
	fmt.Println(query)
	result, err := models.UpdatePerm(dbs.DB, query)
	if err != nil {
		fmt.Println("Error is", err)
	}
	//tools.PanicIf(err)
	//dbs.CloseDB(db)
	fmt.Println("result:", result)
	if result != nil {
		return c.JSON(http.StatusOK, "updated")
	}
	return c.JSON(http.StatusNotFound, "Not updated")
}
